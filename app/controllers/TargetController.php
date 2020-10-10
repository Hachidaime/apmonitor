<?php

use app\controllers\Controller;
use app\models\TargetModel;

class TargetController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);

        $this->targetModel = new TargetModel();

        if (!$_SESSION['USER']['usr_is_package']) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function search()
    {
        list($list, $lcount) = $this->targetModel->multiarray([
            ['pkgd_id', $_POST['pkgd_id']],
        ]);

        foreach ($list as $idx => $row) {
            $list[$idx]['trg_finance'] = number_format(
                $row['trg_finance'],
                2,
                ',',
                '.',
            );
        }

        echo json_encode($list);
        exit();
    }

    public function submit()
    {
        $data = $_POST;
        $data['trg_finance'] = !empty($data['trg_finance'])
            ? str_replace(',', '.', $data['trg_finance'])
            : null;
        if ($this->validate($data)) {
            $result = $this->targetModel->save($data);
            if ($data['id'] > 0) {
                $tag = 'Ubah';
                $id = $data['id'];
            } else {
                $tag = 'Tambah';
                $id = $result;
            }

            if ($result) {
                $this->writeLog(
                    "{$tag} {$this->title}",
                    "{$tag} {$this->title} [{$id}] berhasil.",
                );
                echo json_encode([
                    'success' => true,
                    'msg' => "Berhasil {$tag} {$this->title}.",
                ]);
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
            'trg_week' => "required|min:1|uniq_trg:{$data['pkgd_id']},{$data['id']}",
            'trg_physical' => 'required|numeric',
            'trg_finance' => 'required',
        ]);

        $validation->setAliases([
            'trg_week' => 'Minggu Ke-',
            'trg_physical' => 'Target Fisik',
            'trg_finance' => 'Target Keuangan',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
            'numeric' => '<strong>:attribute</strong> tidak valid.',
            'trg_week:min' => '<strong>:attribute</strong> minimum :min.',
            'trg_week:uniq_trg' =>
                '<strong>:attribute:value</strong> telah ada di database.',
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
        $result = $this->targetModel->delete($id);

        if ($result) {
            $this->writeLog(
                "{$tag} {$this->title}",
                "{$tag} {$this->title} [{$id}] berhasil.",
            );
            echo json_encode([
                'success' => true,
                'msg' => "Berhasil {$tag} {$this->title}.",
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'msg' => "Gagal {$tag} {$this->title}.",
            ]);
        }
        exit();
    }
}
