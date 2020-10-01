<?php
namespace app\models;
use app\models\Model;
use app\models\PackageDetailModel;
use app\models\PackageModel;
use app\models\TargetModel;
use app\models\ProgressModel;

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
    }

    public function getData($data)
    {
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

            $targetOpt = $this->getTargetOpt($pkgIdList);
            $progressOpt = $this->getProgressOpt($pkgIdList);

            foreach ($package as $idx => $row) {
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
                            $detail = [
                                'pkgd_no' => '',
                                'pkgd_name' => '',
                                'pkgd_contract_value' => '',
                            ];
                            $detail['pkgd_no'] = '';
                            $detail['pkgd_name'] = '';
                            $detail['pkgd_contract_value'] = '';
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
                            $detail['pkgd_contract_value'] = '';
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
        return [
            'pkgd_no' => $detail['pkgd_no'],
            'pkgd_name' => $detail['pkgd_name'],
            'pkgd_contract_value' =>
                $detail['pkgd_contract_value'] > 0
                    ? number_format($detail['pkgd_contract_value'], 2, ',', '.')
                    : '',
            'trg_week' => $detail['trg_week'] > 0 ? $detail['trg_week'] : '',
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
        ];
    }

    private function getTargetOpt($pkgIdList)
    {
        $query = "SELECT
            `{$this->packageDetailModel->getTable()}`.`pkg_id`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_no`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_name`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_contract_value`,
            `{$this->targetModel->getTable()}`.`trg_week`,
            `{$this->targetModel->getTable()}`.`trg_physical`,
            `{$this->targetModel->getTable()}`.`trg_finance`
            FROM `{$this->packageDetailModel->getTable()}`
            LEFT JOIN `{$this->targetModel->getTable()}`
                ON `{$this->targetModel->getTable()}`.pkgd_id = `{$this->packageDetailModel->getTable()}`.`id` 
            UNION 
            SELECT
            `{$this->packageDetailModel->getTable()}`.`pkg_id`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_no`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_name`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_contract_value`,
            `{$this->targetModel->getTable()}`.`trg_week`,
            `{$this->targetModel->getTable()}`.`trg_physical`,
            `{$this->targetModel->getTable()}`.`trg_finance`
            FROM `{$this->packageDetailModel->getTable()}`
            RIGHT JOIN `{$this->targetModel->getTable()}`
                ON `{$this->targetModel->getTable()}`.pkgd_id = `{$this->packageDetailModel->getTable()}`.`id` 
            WHERE `{$this->packageDetailModel->getTable()}`.`pkg_id` IN ({$pkgIdList})
        ";
        $target = $this->db->query($query)->toArray();

        $targetOpt = [];
        foreach ($target as $row) {
            $targetOpt[$row['pkg_id']][] = $row;
        }

        return $targetOpt;
    }

    private function getProgressOpt($pkgIdList)
    {
        $query = "SELECT
            `{$this->packageDetailModel->getTable()}`.`pkg_id`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_no`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_name`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_contract_value`,
            `{$this->progressModel->getTable()}`.`prog_physical`,
            `{$this->progressModel->getTable()}`.`prog_finance`
            FROM `{$this->packageDetailModel->getTable()}`
            LEFT JOIN `{$this->progressModel->getTable()}`
                ON `{$this->progressModel->getTable()}`.pkgd_id = `{$this->packageDetailModel->getTable()}`.`id`
            UNION 
            SELECT
            `{$this->packageDetailModel->getTable()}`.`pkg_id`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_no`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_name`,
            `{$this->packageDetailModel->getTable()}`.`pkgd_contract_value`,
            `{$this->progressModel->getTable()}`.`prog_physical`,
            `{$this->progressModel->getTable()}`.`prog_finance`
            FROM `{$this->packageDetailModel->getTable()}`
            RIGHT JOIN `{$this->progressModel->getTable()}`
                ON `{$this->progressModel->getTable()}`.pkgd_id = `{$this->packageDetailModel->getTable()}`.`id`
            WHERE `{$this->packageDetailModel->getTable()}`.`pkg_id` IN ({$pkgIdList})
        ";
        $progress = $this->db->query($query)->toArray();

        $progressOpt = [];
        foreach ($progress as $row) {
            $progressOpt[$row['pkg_id']][] = $row;
        }

        return $progressOpt;
    }
}
