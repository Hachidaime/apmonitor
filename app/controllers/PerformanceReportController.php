<?php
use app\controllers\Controller;
use app\models\ProgramModel;
use app\models\ActivityModel;
use app\models\PerformanceReportModel;
use app\models\PackageModel;
use app\models\PackageDetailModel;

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class PerformanceReportController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->title = 'Capaian Kinerja Bulanan';
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

        $packageModel = new PackageModel();
        list($package, $packageCount) = $packageModel->multiarray();

        $packageDetail = [];
        if ($packageCount > 0) {
            $pkgIdList = implode(
                ',',
                array_map(function ($val) {
                    return $val['id'];
                }, $package),
            );
            $packageDetailModel = new PackageDetailModel();
            $query = "SELECT * FROM `{$packageDetailModel->getTable()}` 
                WHERE `pkg_id` IN ($pkgIdList) 
                ORDER BY `pkgd_name` ASC";
            $packageDetail = $packageDetailModel->db->query($query)->toArray();
        }

        $this->smarty->assign('breadcrumb', [
            ['Laporan', ''],
            [$this->title, ''],
        ]);

        $this->smarty->assign('subtitle', "Laporan {$this->title}");
        $this->smarty->assign('program', $program);
        $this->smarty->assign('activity', $activity);
        $this->smarty->assign('packageDetail', $packageDetail);

        $this->smarty->display("{$this->directory}/index.tpl");
    }

    public function search()
    {
        $list = $this->performanceReportModel->getData($_POST);

        echo json_encode($list);
        exit();
    }

    public function downloadSpreadsheet()
    {
        $colors = [
            'red' => 'FF0000',
            'yellow' => 'FFFF00',
            'green' => '00FF00',
            'white' => 'FFFFFF',
        ];

        $ext = $_POST['ext'] ?? 'xls';

        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();

        $list = $this->performanceReportModel->getData($_POST);
        $list_count = count($list);

        $sheet->setCellValue('A1', 'LAPORAN CAPAIAN KINERJA BULANAN');
        $sheet->setCellValue('A2', 'BINA MARGA KAB. SEMARANG');
        $sheet->setCellValue('A3', "THN ANGGARAN: {$_POST['pkg_fiscal_year']}");

        $sheet->mergeCells('A1:K1');
        $sheet->mergeCells('A2:K2');
        $sheet->mergeCells('A3:K3');

        $sheet->getStyle('A1:A3')->applyFromArray([
            'font' => [
                'bold' => true,
            ],
            'alignment' => [
                'horizontal' =>
                    \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
                'vertical' =>
                    \PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER,
            ],
        ]);

        if ($list_count > 0) {
            foreach ($list as $rows) {
                $prg_row = $prg_row ?? 5;
                $act_row = $prg_row + 1;

                // $sheet->mergeCells("A{$prg_row}:B{$prg_row}");
                $sheet->setCellValue("A{$prg_row}", 'Program:');
                $sheet->setCellValue("B{$prg_row}", $rows['prg_name']);

                // $sheet->mergeCells("A{$act_row}:B{$act_row}");
                $sheet->setCellValue("A{$act_row}", 'Kegiatan:');
                $sheet->setCellValue("B{$act_row}", $rows['act_name']);

                $detail_head1 = $act_row + 1;
                $detail_head2 = $detail_head1 + 1;

                $sheet->mergeCells("A{$detail_head1}:B{$detail_head2}");
                $sheet->mergeCells("C{$detail_head1}:C{$detail_head2}");
                $sheet->mergeCells("D{$detail_head1}:D{$detail_head2}");
                $sheet->mergeCells("E{$detail_head1}:E{$detail_head2}");

                $sheet->mergeCells("F{$detail_head1}:G{$detail_head1}");
                $sheet->mergeCells("H{$detail_head1}:I{$detail_head1}");
                $sheet->mergeCells("J{$detail_head1}:K{$detail_head1}");
                $sheet->mergeCells("L{$detail_head1}:L{$detail_head2}");
                $sheet->getRowDimension($detail_head1)->setRowHeight(30);

                $sheet->fromArray(
                    [
                        // 'No.',
                        'Paket Kegiatan',
                        '',
                        'Nilai Kontrak (Rp)',
                        'Minggu Ke',
                        'Tanggal Periode',
                        'Target',
                        '',
                        'Realisasi',
                        '',
                        'Deviasi',
                        '',
                        "Indi-\nkator",
                    ],
                    null,
                    "A{$detail_head1}",
                );
                $sheet->fromArray(
                    [
                        'Fisik (%)',
                        'Keuangan (Rp)',
                        'Fisik (%)',
                        'Keuangan (Rp)',
                        'Fisik (%)',
                        'Keuangan (Rp)',
                    ],
                    null,
                    "F{$detail_head2}",
                );

                $sheet
                    ->getStyle("A{$detail_head1}:L{$detail_head2}")
                    ->applyFromArray([
                        'font' => [
                            'bold' => true,
                        ],
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

                foreach ($rows['detail'] as $idx => $row) {
                    $n = $idx + 1;
                    $detail_body = $detail_head2 + $n;

                    $sheet->mergeCells("A{$detail_body}:B{$detail_body}");

                    // $sheet->setCellValue("A{$detail_body}", $n);
                    $sheet->setCellValue(
                        "A{$detail_body}",
                        "{$row['pkgd_no']} - {$row['pkgd_name']}",
                    );
                    $sheet->setCellValue("C{$detail_body}", $row['cnt_value']);
                    $sheet->setCellValue("D{$detail_body}", $row['week']);
                    $sheet->setCellValue("E{$detail_body}", $row['trg_date']);
                    $sheet->setCellValue(
                        "F{$detail_body}",
                        $row['trg_physical'],
                    );
                    $sheet->setCellValue(
                        "G{$detail_body}",
                        $row['trg_finance'],
                    );
                    $sheet->setCellValue(
                        "H{$detail_body}",
                        $row['prog_physical'],
                    );
                    $sheet->setCellValue(
                        "I{$detail_body}",
                        $row['prog_finance'],
                    );
                    $sheet->setCellValue(
                        "J{$detail_body}",
                        $row['devn_physical'],
                    );
                    $sheet->setCellValue(
                        "K{$detail_body}",
                        $row['devn_finance'],
                    );

                    $sheet
                        ->getStyle("L{$detail_body}")
                        ->getFill()
                        ->setFillType(
                            \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
                        )
                        ->getStartColor()
                        ->setRGB($colors[$row['indicator']]);

                    $sheet->getStyle("C{$detail_body}")->applyFromArray([
                        'alignment' => [
                            'horizontal' =>
                                \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_RIGHT,
                        ],
                    ]);
                    $sheet
                        ->getStyle("F{$detail_body}:K{$detail_body}")
                        ->applyFromArray([
                            'alignment' => [
                                'horizontal' =>
                                    \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_RIGHT,
                            ],
                        ]);
                }

                $sheet
                    ->getStyle("A{$detail_head2}:L{$detail_body}")
                    ->applyFromArray([
                        'borders' => [
                            'allBorders' => [
                                'borderStyle' =>
                                    \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
                            ],
                        ],
                    ]);

                $prg_row = $detail_body + 2;
            }
        }

        $sheet->getColumnDimension('A')->setAutoSize(true);
        $sheet->getColumnDimension('C')->setAutoSize(true);
        $sheet->getColumnDimension('D')->setAutoSize(true);
        $sheet->getColumnDimension('E')->setAutoSize(true);
        $sheet->getColumnDimension('F')->setAutoSize(true);
        $sheet->getColumnDimension('G')->setAutoSize(true);
        $sheet->getColumnDimension('H')->setAutoSize(true);
        $sheet->getColumnDimension('I')->setAutoSize(true);
        $sheet->getColumnDimension('J')->setAutoSize(true);
        $sheet->getColumnDimension('K')->setAutoSize(true);
        $sheet->getColumnDimension('L')->setAutoSize(true);

        $writer = new Xlsx($spreadsheet);
        $t = time();
        $filename = "Laporan-Capaian-Kinerja-Bulanan-{$t}.{$ext}";
        $filepath = "download/{$filename}";
        $writer->save(DOC_ROOT . $filepath);
        echo json_encode($filepath);
    }
}
