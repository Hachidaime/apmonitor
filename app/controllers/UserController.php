<?php

use app\controllers\Controller;
use app\helper\Flasher;
use app\models\UserModel;

/**
 * @desc this class will handle Uang controller
 *
 * @class BankController
 * @extends Controller
 * @author Hachidaime
 */

class UserController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->smarty->assign('title', $this->title);

        $this->userModel = new UserModel();

        if (!$_SESSION['USER']['usr_is_master']) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function index(int $page = 1, string $keyword = null)
    {
        $keyword = $keyword ?? $_POST['keyword'];
        list($list, $info) = $this->userModel->paginate(
            $page,
            [['usr_name', 'LIKE', "%{$keyword}%"]],
            [['usr_name', 'ASC']],
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
            $detail['usr_is_master'] =
                $detail['usr_is_master'] == 1 ? 'checked' : '';
            $detail['usr_is_package'] =
                $detail['usr_is_package'] == 1 ? 'checked' : '';
            $detail['usr_is_report'] =
                $detail['usr_is_report'] == 1 ? 'checked' : '';
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
        list($detail, $count) = $this->userModel->singlearray([
            ['id', $params],
        ]);
        if (!$count) {
            Flasher::setFlash('Data tidak ditemukan!', $this->name, 'error');
            header('Location: ' . BASE_URL . "/{$this->lowerName}");
        }
        return $detail;
    }

    public function submit()
    {
        $data = $_POST;
        $data['usr_is_master'] = $data['usr_is_master'] ?? 0;
        $data['usr_is_package'] = $data['usr_is_package'] ?? 0;
        $data['usr_is_report'] = $data['usr_is_report'] ?? 0;
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
            $rules['usr_password'] = 'required|max:20|min:6';
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

    public function remove()
    {
        $id = (int) $_POST['id'];
        $tag = 'Hapus';
        $result = $this->userModel->delete($id);

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
