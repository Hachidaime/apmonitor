<?php
use app\controllers\Controller;
use app\models\ProgramModel;
use app\models\ActivityModel;
use app\models\PerformanceReportModel;

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

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

    public function downloadSpreadsheet()
    {
        $ext = $_POST['ext'] ?? 'xls';

        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();

        $list = $this->performanceReportModel->getData($_POST);
        $list_count = count($list);

        $sheet->setCellValue('A1', 'LAPORAN KINERJA PELAKSAAN PAKET KEGIATAN');
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

                $sheet->mergeCells("A{$prg_row}:B{$prg_row}");
                $sheet->setCellValue("A{$prg_row}", 'Program:');
                $sheet->setCellValue("C{$prg_row}", $rows['prg_code']);

                $sheet->mergeCells("A{$act_row}:B{$act_row}");
                $sheet->setCellValue("A{$act_row}", 'Kegiatan:');
                $sheet->setCellValue("C{$act_row}", $rows['act_code']);

                $detail_head1 = $act_row + 1;
                $detail_head2 = $detail_head1 + 1;

                $sheet->mergeCells("A{$detail_head1}:A{$detail_head2}");
                $sheet->mergeCells("B{$detail_head1}:C{$detail_head2}");
                $sheet->mergeCells("D{$detail_head1}:D{$detail_head2}");
                $sheet->mergeCells("E{$detail_head1}:E{$detail_head2}");

                $sheet->mergeCells("F{$detail_head1}:G{$detail_head1}");
                $sheet->mergeCells("H{$detail_head1}:I{$detail_head1}");
                $sheet->mergeCells("J{$detail_head1}:K{$detail_head1}");
                $sheet->getRowDimension($detail_head1)->setRowHeight(30);

                $sheet->fromArray(
                    [
                        'No.',
                        'Paket Kegiatan',
                        '',
                        'Nilai Kontrak (Rp)',
                        'Minggu Ke',
                        'Target',
                        '',
                        'Realisasi',
                        '',
                        'Deviasi',
                        '',
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
                    ->getStyle("A{$detail_head1}:K{$detail_head2}")
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

                    $sheet->mergeCells("B{$detail_body}:C{$detail_body}");

                    $sheet->setCellValue("A{$detail_body}", $n);
                    $sheet->setCellValue(
                        "B{$detail_body}",
                        "{$row['pkgd_no']} - {$row['pkgd_name']}",
                    );
                    $sheet->setCellValue(
                        "D{$detail_body}",
                        $row['pkgd_contract_value'],
                    );
                    $sheet->setCellValue("E{$detail_body}", $row['trg_week']);
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

                    $sheet->getStyle("D{$detail_body}")->applyFromArray([
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
                    ->getStyle("A{$detail_head2}:K{$detail_body}")
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
        $sheet->getColumnDimension('B')->setAutoSize(true);
        $sheet->getColumnDimension('D')->setAutoSize(true);
        $sheet->getColumnDimension('E')->setAutoSize(true);
        $sheet->getColumnDimension('F')->setAutoSize(true);
        $sheet->getColumnDimension('G')->setAutoSize(true);
        $sheet->getColumnDimension('H')->setAutoSize(true);
        $sheet->getColumnDimension('I')->setAutoSize(true);
        $sheet->getColumnDimension('J')->setAutoSize(true);
        $sheet->getColumnDimension('K')->setAutoSize(true);

        $writer = new Xlsx($spreadsheet);
        $t = time();
        $filename = "Laporan-Kinerja-Pelaksanaan-Paket-Kegiatan-{$t}.{$ext}";
        $filepath = "download/{$filename}";
        $writer->save(DOC_ROOT . $filepath);
        echo json_encode($filepath);
    }
}
