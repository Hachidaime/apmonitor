<?php

use app\controllers\Controller;
use app\helper\Functions;
use app\models\PackageDetailModel;

class PartnerController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->title = 'Rekanan';

        $this->packageDetailModel = new PackageDetailModel();

        if (!$_SESSION['USER']['usr_is_package']) {
            header('Location:' . BASE_URL . '/403');
        }
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

        $data['pkgd_contract_date'] = Functions::dateFormat(
            'd/m/Y',
            'Y-m-d',
            $data['pkgd_contract_date'],
        );
        $data['pkgd_contract_end_date'] = Functions::dateFormat(
            'd/m/Y',
            'Y-m-d',
            $data['pkgd_contract_end_date'],
        );
        $data['pkgd_contract_value'] = !empty($data['pkgd_contract_value'])
            ? str_replace(',', '.', $data['pkgd_contract_value'])
            : 0;
        $data['pkgd_addendum_date'] = !empty($data['pkgd_addendum_date'])
            ? Functions::dateFormat(
                'd/m/Y',
                'Y-m-d',
                $data['pkgd_addendum_date'],
            )
            : null;
        $data['pkgd_addendum_end_date'] = !empty(
            $data['pkgd_addendum_end_date']
        )
            ? Functions::dateFormat(
                'd/m/Y',
                'Y-m-d',
                $data['pkgd_addendum_end_date'],
            )
            : null;
        $data['pkgd_addendum_value'] = !empty($data['pkgd_addendum_value'])
            ? str_replace(',', '.', $data['pkgd_addendum_value'])
            : 0;

        foreach ($data as $key => $value) {
            if (empty($value)) {
                unset($data[$key]);
            }
        }
        if ($this->validate($data)) {
            $result = $this->packageDetailModel->save($data);

            $tag = 'Ubah';
            $id = $data['id'];

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
            'pkgd_partner_name' => 'required|max:250',
            'pkgd_contract_no' => 'required|max:50',
            'pkgd_contract_date' => 'required|date',
            'pkgd_contract_days' => 'required',
            'pkgd_contract_end_date' => 'required|date',
            'pkgd_contract_value' => 'required',
            'pkgd_addendum_no' => 'max:50',
            'pkgd_addendum_date' => 'date',
            'pkgd_addendum_end_date' => 'date',
        ]);

        $validation->setAliases([
            'pkgd_partner_name' => 'Nama Rekanan',
            'pkgd_contract_no' => 'Nomor Kontrak',
            'pkgd_contract_date' => 'Tanggal Kontrak',
            'pkgd_contract_days' => 'Masa Kontrak',
            'pkgd_contract_end_date' => 'Tanggal Selesai Kontrak',
            'pkgd_contract_value' => 'Nilai Kontrak',
            'pkgd_addendum_no' => 'Nomor Addendum',
            'pkgd_addendum_date' => 'Tanggal Addendum',
            'pkgd_addendum_end_date' => 'Tanggal Selesai Addendum',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
            'max' => '<strong>:attribute</strong> maximum :max karakter.',
            'date' => 'Format <strong>:attribute</strong> tidak valid.',
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
