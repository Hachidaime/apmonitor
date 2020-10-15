<?php

namespace app\models;

use app\models\Model;

/**
 * @desc this class will handle Dashboard model
 *
 * @class UserModel
 * @author Hachidaime
 */
class DashboardModel extends Model
{
    public function __construct()
    {
        parent::__construct();
        $this->performanceReportModel = new PerformanceReportModel();
    }

    public function activityInfo()
    {
        $list = $this->performanceReportModel->getData();
        foreach ($list as $idx => $row) {
            $red = 0;
            $yellow = 0;
            $green = 0;
            $white = 0;
            $finish = 0;

            foreach ($row['detail'] as $i => $r) {
                foreach ($r as $k => $v) {
                    if (!in_array($k, ['indicator'])) {
                        unset($r[$k]);
                    }
                    $row['detail'][$i] = $r;
                }

                switch ($r['indicator']) {
                    case 'red':
                        $red++;
                        break;

                    case 'yellow':
                        $yellow++;
                        break;

                    case 'green':
                        $green++;
                        break;

                    default:
                        $white++;
                        break;
                }
            }

            $row['detail_count'] = count($row['detail']);

            // var_dump($row);
            // foreach ($row as $key => $value) {
            //     if (!in_array($key, ['prg_name', 'act_name'])) {
            //         unset($row[$key]);
            //     }
            // }
            $row['indicator_red'] = $red;
            $row['indicator_yellow'] = $yellow;
            $row['indicator_green'] = $green;
            $row['indicator_white'] = $white;

            $list[$idx] = $row;
        }
        return $list;
    }
}
