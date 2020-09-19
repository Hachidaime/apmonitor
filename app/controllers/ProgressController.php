<?php

use app\controllers\Controller;
use app\helper\File;
use app\helper\Flasher;
use app\helper\Functions;
use app\models\ProgressModel;
use app\models\PackageDetailModel;

/**
 * @desc this class will handle Uang controller
 *
 * @class BankController
 * @extends Controller
 * @author Hachidaime
 */

class ProgressController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setControllerAttribute(__CLASS__);
        $this->title = 'Progres Paket';
        $this->smarty->assign('title', $this->title);

        $this->progressModel = new ProgressModel();
        $this->packageDetailModel = new PackageDetailModel();

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

        list($packageDetail) = $this->packageDetailModel->multiarray();

        $packageDetailOptions = Functions::listToOptions(
            $packageDetail,
            'id',
            'pkgd_name',
        );

        list($list, $info) = $this->progressModel->paginate($page, null, [
            ['prog_fiscal_year', 'ASC'],
            ['id', 'DESC'],
        ]);

        foreach ($list as $idx => $row) {
            $list[$idx]['prog_date'] = Functions::dateFormat(
                'Y-m-d',
                'd/m/Y',
                $row['prog_date'],
            );
            $list[$idx]['pkgd_name'] = $packageDetailOptions[$row['pkgd_id']];
            $list[$idx]['prog_finance'] = number_format(
                $row['prog_finance'],
                2,
                ',',
                '.',
            );
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
            list(, $count) = $this->progressModel->singlearray($id);
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
        }

        $this->smarty->assign('breadcrumb', [
            ['Master', ''],
            [$this->title, $this->lowerName],
            [$tag, ''],
        ]);

        list($packageDetail) = $this->packageDetailModel->multiarray(null, [
            ['pkgd_no', 'ASC'],
        ]);

        $this->smarty->assign('subtitle', "{$tag} {$this->title}");
        $this->smarty->assign('package_detail', $packageDetail);

        $this->smarty->display("{$this->directory}/form.tpl");
    }

    public function detail()
    {
        list($detail) = $this->progressModel->singlearray($_POST['id']);
        $detail['prog_date'] = Functions::dateFormat(
            'Y-m-d',
            'd/m/Y',
            $detail['prog_date'],
        );

        echo json_encode($detail);
        exit();
    }

    public function submit()
    {
        $data = $_POST;
        $data['prog_date'] = Functions::dateFormat(
            'd/m/Y',
            'Y-m-d',
            $data['prog_date'],
        );
        $data['prog_finance'] = !empty($data['prog_finance'])
            ? str_replace(',', '.', $data['prog_finance'])
            : 0;
        if ($this->validate($data)) {
            $result = $this->progressModel->save($data);
            if ($data['id'] > 0) {
                $tag = 'Ubah';
                $id = $data['id'];
            } else {
                $tag = 'Tambah';
                $id = $result;
            }

            if ($result) {
                $update = ['id' => $id];
                if (!empty($data['prog_img'])) {
                    $imgdir = "img/progress/{$id}";
                    $prog_img = File::moveFromTemp(
                        $imgdir,
                        $data['prog_img'],
                        false,
                        true,
                    );
                    $update['prog_img'] = $prog_img ?? $data['prog_img'];
                }

                if (!empty($data['prog_doc'])) {
                    $docdir = "pdf/progress/{$id}";
                    $prog_doc = File::moveFromTemp(
                        $docdir,
                        $data['prog_doc'],
                        false,
                        true,
                    );
                    $update['prog_doc'] = $prog_doc ?? $data['prog_doc'];
                }

                $this->progressModel->save($update);

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
            'prog_fiscal_year' => 'required',
            'prog_date' => 'required|date',
            'pkgd_id' => 'required',
            'prog_physical' => 'required',
            'prog_img' => 'required',
        ]);

        $validation->setAliases([
            'prog_fiscal_year' => 'Tahun Anggaran',
            'prog_date' => 'Tanggal Progres',
            'pkgd_id' => 'Nama Paket',
            'prog_physical' => 'Progres Fisik',
            'prog_img' => 'Foto',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
            'unique' => '<strong>:attribute</strong> sudah ada di database.',
            'date' => 'Format <strong>:attribute</strong> tidak valid.',
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
        $result = $this->progressModel->delete($id);

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
}
