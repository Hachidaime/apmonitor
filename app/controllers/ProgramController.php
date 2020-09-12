<?php

use app\controllers\Controller;
use app\helper\Flasher;

/**
 * @desc this class will handle Uang controller
 *
 * @class BankController
 * @extends Controller
 * @author Hachidaime
 */

class ProgramController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->smarty->assign('title', $this->title);

        $this->programModel = $this->model("{$this->name}Model");

        if (!$_SESSION['USER']['usr_is_master']) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function index(int $page = 1, string $keyword = null)
    {
        $keyword = $keyword ?? $_POST['keyword'];
        list($list, $info) = $this->programModel->paginate(
            $page,
            [['prg_code', 'LIKE', "%{$keyword}%"]],
            [['prg_code', 'ASC']],
        );
        $info['keyword'] = $keyword;
        $this->pagination($info);

        $this->smarty->assign('breadcrumb', [
            ['Master', ''],
            [$this->title, ''],
        ]);

        $this->smarty->assign('subtitle', "Daftar {$this->title}");
        $this->smarty->assign('keyword', $keyword);
        $this->smarty->assign('list', $list);

        $this->smarty->display("{$this->directory}/index.tpl");
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

        $this->smarty->assign('breadcrumb', [
            ['Master', ''],
            [$this->title, $this->lowerName],
            [$tag, ''],
        ]);

        $this->smarty->assign('subtitle', "{$tag} {$this->title}");
        $this->smarty->assign('detail', $detail);

        $this->smarty->display("{$this->directory}/form.tpl");
    }

    private function getDetail($params)
    {
        list($detail, $count) = $this->programModel->get($params);
        if (!$count) {
            Flasher::setFlash('Data tidak ditemukan!', $this->name, 'error');
            header('Location: ' . BASE_URL . "/{$this->lowerName}");
        }
        return $detail;
    }

    public function submit()
    {
        $data = $_POST;
        $data['prg_code'] = strtoupper(trim($data['prg_code']));
        if ($this->validate($data)) {
            $result = $this->programModel->save($data);
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
        $validation = $this->validator->make($data, [
            'prg_code' => "required|max:20|min:3|unique:{$this->programModel->getTable()},id,{$data['id']}",
            'prg_name' => 'required|max:100|min:6',
            'prg_desc' => 'max:250',
        ]);

        $validation->setAliases([
            'prg_code' => 'Kode Program',
            'prg_name' => 'Nama Program',
            'prg_desc' => 'Deskripsi Program',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
            'unique' => '<strong>:attribute</strong> sudah ada di database.',
            'min' => '<strong>:attribute</strong> minimum :min karakter.',
            'max' => '<strong>:attribute</strong> maximum :max karakter.',
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
        $result = $this->programModel->delete($id);

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
