<?php
namespace app\models;

use app\helper\Functions;
use app\models\Model;
use app\models\PackageDetailModel;
use app\models\PackageModel;
use app\models\TargetModel;
use app\models\ProgressModel;
use app\models\ProgramModel;
use app\models\ActivityModel;

/**
 * @desc this class will handle Program model
 *
 * @class UserModel
 * @author Hachidaime
 */
class ProgressReportModel extends Model
{
    public function __construct()
    {
        parent::__construct();
        $this->packageModel = new PackageModel();
        $this->packageDetailModel = new PackageDetailModel();
        $this->targetModel = new TargetModel();
        $this->progressModel = new ProgressModel();
        $this->contractModel = new ContractModel();
        $this->programModel = new ProgramModel();
        $this->activityModel = new ActivityModel();
    }

    public function getData($data)
    {
        list($program) = $this->programModel->multiarray(null, [
            ['prg_code', 'ASC'],
        ]);
        $programOptions = Functions::listToOptions(
            $program,
            'prg_code',
            'prg_name',
        );

        list($activity) = $this->activityModel->multiarray(null, [
            ['act_code', 'ASC'],
        ]);
        $activityOptions = Functions::listToOptions(
            $activity,
            'act_code',
            'act_name',
        );

        $where = [];
        $where[] = ['pkg_fiscal_year', $data['pkg_fiscal_year']];
        if ($data['prg_code'] != '') {
            $where[] = ['prg_code', $data['prg_code']];
        }
        if ($data['act_code'] != '') {
            $where[] = ['act_code', $data['act_code']];
        }
        list($package, $packageCount) = $this->packageModel->multiarray($where);

        if ($packageCount > 0) {
            $pkgIdList = implode(
                ',',
                array_map(function ($val) {
                    return $val['id'];
                }, $package),
            );

            $targetOpt = $this->getTargetOpt($pkgIdList, $data['pkgd_id']);
            $progressOpt = $this->getProgressOpt($pkgIdList, $data['pkgd_id']);

            foreach ($package as $idx => $row) {
                $row['prg_name'] = $programOptions[$row['prg_code']];
                $row['act_name'] = $activityOptions[$row['act_code']];

                $targetOpt[$row['id']] = $targetOpt[$row['id']] ?? [];
                $progressOpt[$row['id']] = $progressOpt[$row['id']] ?? [];

                if (
                    count($targetOpt[$row['id']]) >
                    count($progressOpt[$row['id']])
                ) {
                    foreach ($targetOpt[$row['id']] as $key => $value) {
                        $progressOpt[$row['id']][$key] = is_array(
                            $progressOpt[$row['id']][$key],
                        )
                            ? $progressOpt[$row['id']][$key]
                            : [];

                        $detail = array_merge(
                            $targetOpt[$row['id']][$key],
                            $progressOpt[$row['id']][$key],
                        );

                        if (
                            $detail['pkgd_no'] ==
                            $row['detail'][$key - 1]['pkgd_no']
                        ) {
                            $detail['pkgd_no'] = '';
                            $detail['pkgd_name'] = '';
                            $detail['cnt_value'] = '';
                        }

                        $row['detail'][$key] = $this->getDetail($detail);
                    }
                } else {
                    foreach ($progressOpt[$row['id']] as $key => $value) {
                        $targetOpt[$row['id']][$key] = is_array(
                            $targetOpt[$row['id']][$key],
                        )
                            ? $targetOpt[$row['id']][$key]
                            : [];

                        $detail = array_merge(
                            $targetOpt[$row['id']][$key],
                            $progressOpt[$row['id']][$key],
                        );

                        if (
                            $detail['pkgd_no'] ==
                            $row['detail'][$key - 1]['pkgd_no']
                        ) {
                            $detail['pkgd_no'] = '';
                            $detail['pkgd_name'] = '';
                            $detail['cnt_value'] = '';
                        }

                        $row['detail'][$key] = $this->getDetail($detail);
                    }
                }

                $package[$idx] = $row;
            }
        }

        return $package;
    }

    public function getDetail($detail)
    {
        $detail['devn_physical'] =
            $detail['prog_physical'] - $detail['trg_physical'];
        $detail['devn_finance'] =
            $detail['prog_finance'] - $detail['trg_finance'];

        return [
            'pkgd_no' => $detail['pkgd_no'],
            'pkgd_name' => $detail['pkgd_name'],
            'cnt_value' =>
                $detail['cnt_value'] > 0
                    ? number_format($detail['cnt_value'], 2, ',', '.')
                    : '',
            'week' => ($detail['trg_week'] > 0
                    ? $detail['trg_week']
                    : $detail['prog_week'] > 0)
                ? $detail['prog_week']
                : '',
            'trg_date' => !is_null($detail['trg_date'])
                ? Functions::dateFormat('Y-m-d', 'd/m/Y', $detail['trg_date'])
                : '',
            'trg_physical' =>
                $detail['trg_physical'] > 0
                    ? number_format($detail['trg_physical'], 2, ',', '.')
                    : '',
            'trg_finance' =>
                $detail['trg_finance'] > 0
                    ? number_format($detail['trg_finance'], 2, ',', '.')
                    : '',
            'prog_physical' =>
                $detail['prog_physical'] > 0
                    ? number_format($detail['prog_physical'], 2, ',', '.')
                    : '',
            'prog_finance' =>
                $detail['prog_finance'] > 0
                    ? number_format($detail['prog_finance'], 2, ',', '.')
                    : '',
            'devn_physical' => !empty($detail['devn_physical'])
                ? number_format($detail['devn_physical'], 2, ',', '.')
                : '',
            'devn_finance' => !empty($detail['devn_finance'])
                ? number_format($detail['devn_finance'], 2, ',', '.')
                : '',
        ];
    }

    private function getTargetOpt($pkgIdList, $pkgd_id = null)
    {
        $filter =
            $pkgd_id > 0
                ? "AND `{$this->packageDetailModel->getTable()}`.`id` = {$pkgd_id}"
                : '';

        $table_left = $this->packageDetailModel->getTable();
        $table_right = $this->targetModel->getTable();
        $table_contract = $this->contractModel->getTable();
        $select = "
            `{$table_left}`.`id`,
            `{$table_left}`.`pkg_id`,
            `{$table_left}`.`pkgd_no`,
            `{$table_left}`.`pkgd_name`,
            `{$table_right}`.`trg_week`,
            `{$table_right}`.`trg_date`,
            `{$table_right}`.`trg_physical`,
            `{$table_right}`.`trg_finance`,
            `{$table_contract}`.`cnt_value`
        ";
        $join = "`{$table_right}`
            ON `{$table_right}`.`pkgd_id` = `{$table_left}`.`id`";
        $join_contract = "`{$table_contract}`
            ON `{$table_contract}`.`pkgd_id` = `{$table_left}`.`id`";
        $where = "WHERE `{$table_left}`.`pkg_id` IN ({$pkgIdList})
            {$filter}";

        $query = "SELECT {$select} FROM `{$table_left}` 
            LEFT JOIN {$join} 
            LEFT JOIN {$join_contract}
            {$where}
            UNION 
            SELECT {$select} FROM `{$table_left}` 
            RIGHT JOIN {$join} 
            LEFT JOIN {$join_contract}
            {$where}";
        $target = $this->db->query($query)->toArray();
        // echo nl2br($query);

        $targetOpt = [];
        foreach ($target as $row) {
            $targetOpt[$row['pkg_id']][] = $row;
        }

        return $targetOpt;
    }

    private function getProgressOpt($pkgIdList, $pkgd_id = null)
    {
        $filter =
            $pkgd_id > 0
                ? "AND `{$this->packageDetailModel->getTable()}`.`id` = {$pkgd_id}"
                : '';

        $table_left = $this->packageDetailModel->getTable();
        $table_right = $this->progressModel->getTable();
        $table_contract = $this->contractModel->getTable();
        $select = "
            `{$table_left}`.`id`,
            `{$table_left}`.`pkg_id`,
            `{$table_left}`.`pkgd_no`,
            `{$table_left}`.`pkgd_name`,
            `{$table_right}`.`prog_week`,
            `{$table_right}`.`prog_physical`,
            `{$table_right}`.`prog_finance`,
            `{$table_contract}`.`cnt_value`
        ";
        $join = "`{$table_right}`
            ON `{$table_right}`.`pkgd_id` = `{$table_left}`.`id`";
        $join_contract = "`{$table_contract}`
            ON `{$table_contract}`.`pkgd_id` = `{$table_left}`.`id`";
        $where = "WHERE `{$table_left}`.`pkg_id` IN ({$pkgIdList})
            {$filter}";

        $query = "SELECT {$select} FROM `{$table_left}` 
            LEFT JOIN {$join} 
            LEFT JOIN {$join_contract}
            {$where}
            UNION 
            SELECT {$select} FROM `{$table_left}` 
            RIGHT JOIN {$join} 
            LEFT JOIN {$join_contract}
            {$where}";
        $progress = $this->db->query($query)->toArray();

        $progressOpt = [];
        foreach ($progress as $row) {
            $progressOpt[$row['pkg_id']][] = $row;
        }

        return $progressOpt;
    }
}
