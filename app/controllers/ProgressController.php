<?php

use app\controllers\Controller;
use app\helper\Flasher;
use app\helper\Functions;

/**
 * @desc this class will handle Uang controller
 *
 * @class BankController
 * @extends Controller
 * @author Hachidaime
 */

class ProgressController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->progressModel = $this->model("{$this->name}Model");
        $this->title = 'Progres Paket';
        $this->smarty->assign('title', $this->title);

        $access = [1, 2, 3];
        if (!in_array($_SESSION['USER']['usr_access'], $access)) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function index(int $page = 1, string $keyword = null)
    {
        $keyword = $keyword ?? $_POST['keyword'];
        list($list, $info) = $this->progressModel->paginate(
            $page,
            // [['pkt_code', 'LIKE', "%{$keyword}%"]],
            // [['pkt_code', 'ASC']],
        );
        $info['keyword'] = $keyword;
        $this->pagination($info);

        $this->smarty->assign('subtitle', "Daftar {$this->title}");
        $this->smarty->assign('keyword', $keyword);
        $this->smarty->assign('list', $list);
        $this->smarty->display("{$this->directory}/index.tpl");
    }

    public function detail(int $id)
    {
        $detail = $this->getDetail($id);

        $this->smarty->assign('detail', $detail);
        $this->smarty->assign('subtitle', "Detail {$this->title}");
        $this->smarty->display("{$this->directory}/detail.tpl");
    }

    /**
     * @desc this method will handle Data Uang form
     *
     * @method form
     * @param int $id is mata uang id
     */
    public function form(int $id = null)
    {
        $tag = 'Tambah';
        if (!is_null($id)) {
            $detail = $this->getDetail($id);
            $tag = 'Ubah';
        }

        $this->smarty->assign('detail', $detail);
        $this->smarty->assign('subtitle', "{$tag} {$this->title}");
        $this->smarty->display("{$this->directory}/form.tpl");
    }

    private function getDetail($params)
    {
        list($detail, $count) = $this->progressModel->get($params);
        if (!$count) {
            Flasher::setFlash('Data tidak ditemukan!', $this->name, 'error');
            header('Location: ' . BASE_URL . "/{$this->lowerName}");
        }
        return $detail;
    }

    public function submit()
    {
        $data = $_POST;
        if ($this->validate($data)) {
            $result = $this->progressModel->save($data);
            if ($data['id'] > 0) {
                $tag = 'Ubah';
                $id = $data['id'];
            } else {
                $tag = 'Tambah';
                $id = $result;
            }

            if ($result) {
                Flasher::setFlash(
                    "Berhasil {$tag} {$this->title}.",
                    $this->name,
                    'success',
                );
                $this->writeLog(
                    "{$tag} {$this->title}",
                    "{$tag} {$this->title} [{$id}] berhasil.",
                );
                echo json_encode(['success' => true]);
            } else {
                echo json_encode([
                    'success' => false,
                    'msg' => "Gagal {$tag} {$this->title}.",
                ]);
            }
            exit();
        }
    }

    public function validate($data)
    {
        $data['prog_physical'] = (float) $data['prog_physical'];
        $data['prog_finance'] = (float) $data['prog_finance'];
        $validation = $this->validator->make($data, [
            'prog_physical' => 'required|between:0,100',
            'prog_finance' => 'required|between:0,100',
        ]);

        $validation->setAliases([
            'prog_physical' => 'Fisik',
            'prog_finance' => 'Keuangan',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
            'unique' => '<strong>:attribute</strong> sudah ada di database.',
            'between' => '<strong>:attribute</strong> tidak valid.',
        ]);

        $validation->validate();

        if ($validation->fails()) {
            echo json_encode([
                'success' => false,
                'msg' => $validation->errors()->firstOfAll(),
            ]);
            exit();
        }
        return true;
    }

    public function remove()
    {
        $id = (int) $_POST['id'];
        $tag = 'Hapus';
        $result = $this->progressModel->delete($id);

        if ($result) {
            Flasher::setFlash(
                "Berhasil {$tag} {$this->title}.",
                $this->name,
                'success',
            );
            $this->writeLog(
                "{$tag} {$this->title}",
                "{$tag} {$this->title} [{$id}] berhasil.",
            );
            echo json_encode(['success' => true]);
        } else {
            echo json_encode([
                'success' => false,
                'msg' => "Gagal {$tag} {$this->title}.",
            ]);
        }
        exit();
    }
}
