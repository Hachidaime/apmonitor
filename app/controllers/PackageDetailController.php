<?php

use app\controllers\Controller;
use app\helper\Functions;
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
            ['pkg_id', $detail['id'] > 0 ? $detail['id'] : 0],
            [
                'pkgs_id',
                $detail['pkgs_id'] > 0
                    ? $detail['pkgs_id']
                    : $_SESSION['PKGS_ID'],
            ],
        ]);

        foreach ($list as $idx => $row) {
            $list[$idx]['pkgd_contract_date'] = !is_null(
                $row['pkgd_contract_date'],
            )
                ? Functions::dateFormat(
                    'Y-m-d',
                    'd/m/Y',
                    $row['pkgd_contract_date'],
                )
                : null;

            $list[$idx]['pkgd_contract_end_date'] = !is_null(
                $row['pkgd_contract_end_date'],
            )
                ? Functions::dateFormat(
                    'Y-m-d',
                    'd/m/Y',
                    $row['pkgd_contract_end_date'],
                )
                : null;

            $list[$idx]['pkgd_addendum_date'] = !is_null(
                $row['pkgd_addendum_date'],
            )
                ? Functions::dateFormat(
                    'Y-m-d',
                    'd/m/Y',
                    $row['pkgd_addendum_date'],
                )
                : null;

            $list[$idx]['pkgd_addendum_end_date'] = !is_null(
                $row['pkgd_addendum_end_date'],
            )
                ? Functions::dateFormat(
                    'Y-m-d',
                    'd/m/Y',
                    $row['pkgd_addendum_end_date'],
                )
                : null;

            $list[$idx]['pkgd_last_prog_date'] = !is_null(
                $row['pkgd_last_prog_date'],
            )
                ? Functions::dateFormat(
                    'Y-m-d',
                    'd/m/Y',
                    $row['pkgd_last_prog_date'],
                )
                : null;

            $list[$idx]['pkgd_sum_prog_physical'] = number_format(
                $row['pkgd_sum_prog_physical'],
                2,
                ',',
                '.',
            );

            $list[$idx]['pkgd_sum_prog_finance'] = number_format(
                $row['pkgd_sum_prog_finance'],
                2,
                ',',
                '.',
            );
        }

        echo json_encode($list);
        exit();
    }

    public function detail()
    {
        list($detail) = $this->packageDetailModel->singlearray($_POST['id']);
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
            'pkgd_no' => "required|uniq_pkgd_no:{$data['pkgs_id']},{$data['id']}",
            'pkgd_name' => 'required',
        ]);

        $validation->setAliases([
            'pkgd_no' => 'Nomor Paket',
            'pkgd_name' => 'Nama Paket',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
            'pkgd_no:uniq_pkgd_no' => 'Data sudah ada di database.',
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
