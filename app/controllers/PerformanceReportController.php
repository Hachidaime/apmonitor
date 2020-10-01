<?php
use app\controllers\Controller;
use app\models\ProgramModel;
use app\models\ActivityModel;
use app\models\PerformanceReportModel;

class PerformanceReportController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->title = 'Kinerja Pelaksanaan Paket Kegiatan';
        $this->smarty->assign('title', $this->title);
        $this->performanceReportModel = new PerformanceReportModel();

        if (!$_SESSION['USER']['usr_is_report']) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function index()
    {
        $programModel = new ProgramModel();
        list($program) = $programModel->multiarray(null, [['prg_code', 'ASC']]);

        $activityModel = new ActivityModel();
        list($activity) = $activityModel->multiarray(null, [
            ['act_code', 'ASC'],
        ]);

        $this->smarty->assign('breadcrumb', [
            ['Laporan', ''],
            [$this->title, ''],
        ]);

        $this->smarty->assign('subtitle', "Laporan {$this->title}");
        $this->smarty->assign('program', $program);
        $this->smarty->assign('activity', $activity);

        $this->smarty->display("{$this->directory}/index.tpl");
    }

    public function search()
    {
        $list = $this->performanceReportModel->getData($_POST);

        echo json_encode($list);
        exit();
    }
}
