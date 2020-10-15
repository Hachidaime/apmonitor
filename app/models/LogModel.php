<?php
namespace app\models;

use app\models\Model;

class LogModel extends Model
{
    /**
     * Table name
     *
     * @var string
     * @access protected
     */
    protected $table = 'apm_log';

    /**
     * function lastActivity
     *
     * This method will handle to return last activity log
     *
     * @access public
     * @param int $limit the number of last logs displayed
     * @return array [list, list_count]
     */
    public function getLastActivity(int $limit = 5)
    {
        $list = $this->db
            ->table($this->table)
            ->orderBy('created_at', 'DESC')
            ->limit($limit)
            ->get()
            ->toArray();

        return [$list, $this->db->paginationInfo()];
    }
}
