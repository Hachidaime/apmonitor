<?php

use app\controllers\Controller;
/**
 * Class DashboardController
 *
 * This class will handle User controller
 *
 * @author Hachidaime
 */

class DashboardController extends Controller
{
    /**
     * function index
     *
     * This method will handle default Dashboard page
     *
     * @access public
     */
    public function index()
    {
        $this->smarty->assign('title', 'Dashboard');
        $this->smarty->assign('lastActivity', $this->lastActivity(10));
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
        list($list) = $this->model('LogModel')->getLastActivity($limit);

        $result = [
            'title' => 'Aktivitas Terakhir',
            'list' => $list,
        ];
        return $result;
    }
}
