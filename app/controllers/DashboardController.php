<?php

use app\controllers\Controller;
use app\models\DashboardModel;
use app\models\LogModel;

/**
 * Class DashboardController
 *
 * This class will handle User controller
 *
 * @author Hachidaime
 */

class DashboardController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->smarty->assign('title', $this->title);

        $this->dashboardModel = new DashboardModel();
        $this->logModel = new LogModel();
    }
    /**
     * function index
     *
     * This method will handle default Dashboard page
     *
     * @access public
     */
    public function index()
    {
        // $this->smarty->assign('lastActivity', $this->lastActivity(10));

        $activityInfo = $this->dashboardModel->activityInfo();

        // print '<pre>';
        // print_r($activityInfo);
        // print '</pre>';
        $this->smarty->display('Dashboard/index.tpl');
    }

    /**
     * function lastActivity
     *
     * This method will handle to return last activity log
     *
     * @access private
     * @param int $limit the number of last logs displayed
     * @return array ['title', 'list']
     */
    private function lastActivity(int $limit = null)
    {
        list($list) = $this->logModel->getLastActivity($limit);

        $result = [
            'title' => 'Aktivitas Terakhir',
            'list' => $list,
        ];
        return $result;
    }
}
