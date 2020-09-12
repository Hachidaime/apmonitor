<?php

use app\controllers\Controller;
use app\helper\Flasher;

class ProfileController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->userModel = $this->model('UserModel');
        $this->smarty->assign('title', $this->title);

        $this->id = $_SESSION['USER']['id'];
    }

    public function index()
    {
        $detail = $this->getDetail($this->id);

        $this->smarty->assign('detail', $detail);
        $this->smarty->assign('subtitle', "Detail {$this->title}");
        $this->smarty->display("{$this->directory}/detail.tpl");
    }

    public function form()
    {
        $detail = $this->getDetail($this->id);
        $tag = 'Ubah';

        $this->smarty->assign('detail', $detail);
        $this->smarty->assign('subtitle', "{$tag} {$this->title}");
        $this->smarty->display("{$this->directory}/form.tpl");
    }

    private function getDetail($params)
    {
        list($detail, $count) = $this->userModel->get($params);
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
            if (empty($data['usr_password'])) {
                unset($data['usr_password']);
            }

            $result = $this->userModel->save($data);
            if ($data['id'] > 0) {
                $tag = 'Ubah';
                $id = $data['id'];
            } else {
                $tag = 'Tambah';
                $id = $result;
            }

            if ($result) {
                $detail = $this->getDetail($id);

                if ($id == $_SESSION['USER']['id']) {
                    $this->setUserSession($detail);
                }

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
        $rules = [
            'usr_name' => 'required',
            'usr_username' => "required|max:20|min:3|unique:{$this->userModel->getTable()},id,{$data['id']}",
        ];

        if (empty($data['id'])) {
            $rules['usr_password'] = 'required|max:20|min:3';
        }

        $validation = $this->validator->make($data, $rules);

        $validation->setAliases([
            'usr_name' => 'Nama',
            'usr_username' => 'Username',
            'usr_password' => 'Password',
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
}
?>
