<?php

use app\controllers\Controller;
use app\helper\Flasher;

class PackageDetailController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);

        $this->packageDetailModel = $this->model("{$this->name}Model");

        if (!$_SESSION['USER']['usr_is_package']) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function index()
    {
        list($list) = $this->packageDetailModel->get(
            [['pkgs_id', $_POST['pkgs_id']]],
            [['pkgd_no', 'ASC']],
        );

        echo json_encode($list);
        exit();
    }

    public function detail(int $pkgd_no)
    {
        $detail = $this->getDetail($pkgd_no);
    }

    private function getDetail($params)
    {
        list($detail, $count) = $this->packageModel->get($params);
        if (!$count) {
            Flasher::setFlash('Data tidak ditemukan!', $this->name, 'error');
            header('Location: ' . BASE_URL . "/{$this->lowerName}");
        }
        return $detail;
    }
}
