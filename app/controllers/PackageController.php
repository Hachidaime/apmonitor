<?php

use app\controllers\Controller;
use app\helper\Flasher;
use app\helper\Functions;
use app\models\ActivityModel;
use app\models\PackageDetailModel;
use app\models\PackageModel;
use app\models\PackageSessionModel;
use app\models\ProgramModel;

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

/**
 * @desc this class will handle Uang controller
 *
 * @class BankController
 * @extends Controller
 * @author Hachidaime
 */

class PackageController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->title = 'Pemaketan';
        $this->smarty->assign('title', $this->title);

        $this->packageModel = new PackageModel();

        if (!$_SESSION['USER']['usr_is_package']) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function index()
    {
        $this->smarty->assign('breadcrumb', [
            ['Master', ''],
            [$this->title, ''],
        ]);

        $this->smarty->assign('subtitle', "Daftar {$this->title}");

        $this->smarty->display("{$this->directory}/index.tpl");
    }

    public function search(int $page = 1, string $keyword = null)
    {
        $page = $_POST['page'] ?? 1;
        $keyword = $_POST['keyword'] ?? null;

        $programModel = new ProgramModel();
        list($program) = $programModel->multiarray(null, [['prg_code', 'ASC']]);

        $programOptions = Functions::listToOptions(
            $program,
            'prg_code',
            'prg_name',
        );

        $activityModel = new ActivityModel();
        list($activity) = $activityModel->multiarray(null, [
            ['act_code', 'ASC'],
        ]);

        $activityOptions = Functions::listToOptions(
            $activity,
            'act_code',
            'act_name',
        );

        list($list, $info) = $this->packageModel->paginate(
            $page,
            [['pkg_fiscal_year', 'LIKE', "%{$keyword}%"]],
            [
                ['pkg_fiscal_year', 'DESC'],
                ['prg_code', 'ASC'],
                ['act_code', 'ASC'],
            ],
        );

        foreach ($list as $idx => $row) {
            $list[$idx]['prg_name'] = $programOptions[$row['prg_code']];
            $list[$idx]['act_name'] = $activityOptions[$row['act_code']];
        }

        echo json_encode([
            'list' => $list,
            'info' => $info,
        ]);
        exit();
    }

    /**
     * @desc this method will handle Data Uang form
     *
     * @method form
     * @param int $id is mata uang id
     */
    public function form(int $id = null)
    {
        $tag = 'Tambah';
        if (!is_null($id)) {
            list(, $count) = $this->packageModel->singlearray($id);
            if (!$count) {
                Flasher::setFlash(
                    'Data tidak ditemukan!',
                    $this->name,
                    'error',
                );
                header('Location: ' . BASE_URL . "/{$this->lowerName}");
            }

            $tag = 'Ubah';
            $this->smarty->assign('id', $id);
        } else {
            $packageSessionModel = new PackageSessionModel();
            $pkgs_id = $packageSessionModel->getPackageSessionId();
            $_SESSION['PKGS_ID'] = $pkgs_id;
        }

        $programModel = new ProgramModel();
        list($program) = $programModel->multiarray(null, [['prg_code', 'ASC']]);

        $activityModel = new ActivityModel();
        list($activity) = $activityModel->multiarray(null, [
            ['act_code', 'ASC'],
        ]);

        $this->smarty->assign('breadcrumb', [
            ['Master', ''],
            [$this->title, $this->lowerName],
            [$tag, ''],
        ]);

        $this->smarty->assign('subtitle', "{$tag} {$this->title}");
        $this->smarty->assign('program', $program);
        $this->smarty->assign('activity', $activity);
        $this->smarty->display("{$this->directory}/form.tpl");
    }

    public function detail()
    {
        list($detail) = $this->packageModel->singlearray($_POST['id']);
        if (!empty($detail['pkgs_id'])) {
            $_SESSION['PKGS_ID'] = $detail['pkgs_id'];
        } else {
            $packageSessionModel = new PackageSessionModel();
            $_SESSION['PKGS_ID'] = $packageSessionModel->getPackageSessionId();
        }
        echo json_encode($detail);
        exit();
    }

    public function submit()
    {
        $data = $_POST;
        $data['pkgs_id'] = $_SESSION['PKGS_ID'];
        if ($this->validate($data)) {
            $result = $this->packageModel->save($data);
            if ($data['id'] > 0) {
                $tag = 'Ubah';
                $id = $data['id'];
            } else {
                $tag = 'Tambah';
                $id = $result;
            }

            if ($result) {
                $packageDetailModel = new PackageDetailModel();
                $packageDetailModel->db->update(
                    $packageDetailModel->getTable(),
                    ['pkg_id' => $id],
                    [['pkgs_id', $data['pkgs_id']]],
                );
                Flasher::setFlash(
                    "Berhasil {$tag} {$this->title}.",
                    $this->name,
                    'success',
                );
                $this->writeLog(
                    "{$tag} {$this->title}",
                    "{$tag} {$this->title} [{$id}] berhasil.",
                );
                echo json_encode(['success' => true]);
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
            'pkg_fiscal_year' => 'required|digits:4',
            'prg_code' => 'required',
            'act_code' => "required|uniq_pkg_act:{$data['pkg_fiscal_year']},{$data['prg_code']},{$data['id']}",
        ]);

        $validation->setAliases([
            'pkg_fiscal_year' => 'Tahun Anggaran',
            'prg_code' => 'Kode Program',
            'act_code' => 'Kode Kegiatan',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
            'act_code:uniq_pkg_act' =>
                '<strong>Program</strong> dan <strong>:attribute</strong> sudah ada di database.',
            'pkg_fiscal_year:digits' =>
                'Format <strong>:attribute</strong> salah.',
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

    public function remove()
    {
        $id = (int) $_POST['id'];
        $tag = 'Hapus';
        $result = $this->packageModel->delete($id);

        if ($result) {
            Flasher::setFlash(
                "Berhasil {$tag} {$this->title}.",
                $this->name,
                'success',
            );
            $this->writeLog(
                "{$tag} {$this->title}",
                "{$tag} {$this->title} [{$id}] berhasil.",
            );
            echo json_encode(['success' => true]);
        } else {
            echo json_encode([
                'success' => false,
                'msg' => "Gagal {$tag} {$this->title}.",
            ]);
        }
        exit();
    }

    public function downloadSpreadsheet()
    {
        $ext = $_POST['ext'] ?? 'xls';

        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();

        list($list, $list_count) = $this->searchAll();

        $spreadsheet
            ->getActiveSheet()
            ->fromArray(
                ['No.', "Tahun\nAnggaran", 'Program', 'Kegiatan'],
                null,
                'A1',
            );

        $spreadsheet
            ->getActiveSheet()
            ->getRowDimension('1')
            ->setRowHeight(30);

        $spreadsheet
            ->getActiveSheet()
            ->getStyle('A1:D1')
            ->applyFromArray([
                'alignment' => [
                    'horizontal' =>
                        \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
                    'vertical' =>
                        \PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER,
                ],
                'borders' => [
                    'allBorders' => [
                        'borderStyle' =>
                            \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
                    ],
                ],
            ]);

        if ($list_count > 0) {
            foreach ($list as $idx => $rows) {
                $row = $idx + 2;
                $n = $idx + 1;
                $sheet->setCellValue("A{$row}", $n);
                $sheet->setCellValue("B{$row}", $rows['pkg_fiscal_year']);
                $sheet->setCellValue("C{$row}", $rows['prg_name']);
                $sheet->setCellValue("D{$row}", $rows['act_name']);
            }

            $spreadsheet
                ->getActiveSheet()
                ->getStyle("A2:D{$row}")
                ->applyFromArray([
                    'borders' => [
                        'allBorders' => [
                            'borderStyle' =>
                                \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
                        ],
                    ],
                ]);
        }

        $spreadsheet
            ->getActiveSheet()
            ->getColumnDimension('A')
            ->setAutoSize(true);
        $spreadsheet
            ->getActiveSheet()
            ->getColumnDimension('B')
            ->setAutoSize(true);
        $spreadsheet
            ->getActiveSheet()
            ->getColumnDimension('C')
            ->setAutoSize(true);
        $spreadsheet
            ->getActiveSheet()
            ->getColumnDimension('D')
            ->setAutoSize(true);

        $writer = new Xlsx($spreadsheet);
        $t = time();
        $filename = "Pemaketan-{$t}.{$ext}";
        $filepath = "download/{$filename}";
        $writer->save(DOC_ROOT . $filepath);
        echo json_encode($filepath);
    }

    public function searchAll()
    {
        $keyword = $_POST['keyword'] ?? null;

        $programModel = new ProgramModel();
        list($program) = $programModel->multiarray(null, [['prg_code', 'ASC']]);

        $programOptions = Functions::listToOptions(
            $program,
            'prg_code',
            'prg_name',
        );

        $activityModel = new ActivityModel();
        list($activity) = $activityModel->multiarray(null, [
            ['act_code', 'ASC'],
        ]);

        $activityOptions = Functions::listToOptions(
            $activity,
            'act_code',
            'act_name',
        );

        list($list, $list_count) = $this->packageModel->multiarray(
            [['pkg_fiscal_year', 'LIKE', "%{$keyword}%"]],
            [
                ['pkg_fiscal_year', 'DESC'],
                ['prg_code', 'ASC'],
                ['act_code', 'ASC'],
            ],
        );

        foreach ($list as $idx => $row) {
            $list[$idx]['prg_name'] = $programOptions[$row['prg_code']];
            $list[$idx]['act_name'] = $activityOptions[$row['act_code']];
        }

        return [$list, $list_count];
    }
}
