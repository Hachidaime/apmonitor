<?php

use app\controllers\Controller;
use app\helper\Flasher;
use app\models\PackageDetailModel;
use app\models\PackageModel;

class PackageDetailController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);

        $this->packageDetailModel = new PackageDetailModel();

        if (!$_SESSION['USER']['usr_is_package']) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function search()
    {
        $packageModel = new PackageModel();
        list($detail, $dcount) = $packageModel->singlearray($_POST['pkg_id']);

        list($list, $lcount) = $this->packageDetailModel->multiarray([
            ['pkg_id', $detail['id']],
            ['pkgs_id', $detail['pkgs_id']],
        ]);

        echo json_encode($list);
        exit();
    }

    public function detail(int $pkgd_no)
    {
        list($detail) = $this->packageModel->get([['pkgd_no', $pkgd_no]]);
        echo json_encode($detail);
        exit();
    }

    public function submit()
    {
        $data = $_POST;
        $data['pkgd_no'] = strtoupper($data['pkgd_no']);
        $data['pkgs_id'] = $_SESSION['PKGS_ID'];
        $data['pkg_id'] = !empty($data['pkg_id']) ? $data['pkg_id'] : 0;
        if ($this->validate($data)) {
            $result = $this->packageDetailModel->save($data);
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
            'pkgd_no' => 'required',
            'pkgd_name' => 'required',
            'pkgd_period_type' => 'required',
        ]);

        $validation->setAliases([
            'pkgd_no' => 'Nomor Paket',
            'pkgd_name' => 'Nama Paket',
            'pkgd_period_type' => 'Jenis Masa',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
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
