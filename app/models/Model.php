<?php

namespace app\models;

/**
 * Class Model
 *
 * Model menyediakan tempat nyaman
 * untuk memuat komponen dan melakukan fungsi
 * yang dibutuhkan oleh semua Model.
 *
 * Extends Class ini dalam Model baru:
 *
 *   class HomeModel extends Model
 *
 * Untuk keamanan pastikan untuk menyatakan setiap method baru
 * sebagai protected atau private.
 *
 * PHP VERSION 7
 *
 * @package DB
 * @see https://github.com/mareimorsy/DB
 * @author Hachidaime
 */
class Model
{
    /**
     * function __construct
     *
     * Constuctor
     *
     * @access public
     */
    public function __construct()
    {
        global $db;
        $this->db = &$db;
    }

    /**
     * function getTable
     *
     * Mendapatkan nama table
     *
     * @access public
     * @return string nama table
     */
    public function getTable()
    {
        return $this->table;
    }

    public function paginate(
        int $page = 1,
        array $params = null,
        array $orders = null
    ) {
        $list = $this->db->table($this->table);

        $list = !is_null($params)
            ? $list->orWhere($params)
            : $list->where([['id', '>', 0]]);

        if (!is_null($orders)) {
            foreach ($orders as $value) {
                $list =
                    count($value) == 2
                        ? $list->orderBy($value[0], $value[1])
                        : $list->orderBy($value[0], 'ASC');
            }
        }

        $list = $list->paginate($page, ROWS_PER_PAGE);

        $list = !empty($list) ? $list->toArray() : $list;

        return [$list, $this->db->paginationInfo()];
    }

    public function get($params = null, $orders = null)
    {
        $result = $this->db->table($this->table);

        $result = !is_null($params)
            ? $result->orWhere($params)
            : $result->where([['id', '>', 0]]);

        if (!is_null($orders)) {
            foreach ($orders as $value) {
                $result =
                    count($value) == 2
                        ? $result->orderBy($value[0], $value[1])
                        : $result->orderBy($value[0], 'ASC');
            }
        }

        $result =
            !is_array($params) && !is_null($params)
                ? $result->get()->first()
                : $result->get();

        $result = !empty($result) ? $result->toArray() : $result;
        return [$result, $this->db->getCount()];
    }

    public function save($data = [])
    {
        $data = array_map(function ($item) {
            return trim($item);
        }, $data);

        if ($data['id'] > 0) {
            list($detail) = $this->get($data['id']);
            foreach ($detail as $key => $value) {
                if (!in_array($key, array_keys($data))) {
                    unset($detail[$key]);
                }
            }

            $result =
                $detail == $data
                    ? 1
                    : ($result = $this->db->update(
                        $this->table,
                        $data,
                        $data['id'],
                    ));
        } else {
            unset($data['id']);
            $result = $this->db->insert($this->table, $data);
        }

        return $result;
    }

    public function delete(int $id)
    {
        $result = $this->db->delete($this->table, $id);
        return $result;
    }
}
