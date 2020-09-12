<?php

use app\controllers\Controller;
use app\helper\Flasher;
use app\helper\Functions;

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

        $this->packageModel = $this->model("{$this->name}Model");

        if (!$_SESSION['USER']['usr_is_package']) {
            header('Location:' . BASE_URL . '/403');
        }
    }

    public function index(int $page = 1, string $keyword = null)
    {
        $keyword = $keyword ?? $_POST['keyword'];
        list($list, $info) = $this->packageModel->paginate(
            $page,
            [['pkg_fiscal_year', 'LIKE', "%{$keyword}%"]],
            [
                ['pkg_fiscal_year', 'DESC'],
                ['prg_code', 'ASC'],
                ['act_code', 'ASC'],
            ],
        );
        $info['keyword'] = $keyword;
        $this->pagination($info);

        $this->smarty->assign('breadcrumb', [
            ['Master', ''],
            [$this->title, ''],
        ]);

        $this->smarty->assign('subtitle', "Daftar {$this->title}");
        $this->smarty->assign('keyword', $keyword);
        $this->smarty->assign('list', $list);
        $this->smarty->display("{$this->directory}/index.tpl");
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
            $detail = $this->getDetail($id);
            $tag = 'Ubah';
        }

        $detail['pkg_fiscal_year'] =
            $detail['pkg_fiscal_year'] ?? $_SESSION['FISCAL_YEAR'];

        list($program) = $this->model('ProgramModel')->get(null, [
            ['prg_code', 'ASC'],
        ]);

        list($activity) = $this->model('ActivityModel')->get(null, [
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
        $this->smarty->assign('detail', $detail);
        $this->smarty->display("{$this->directory}/form.tpl");
    }

    private function getDetail($params)
    {
        list($detail, $count) = $this->packageModel->get($params);
        if (!$count) {
            Flasher::setFlash('Data tidak ditemukan!', $this->name, 'error');
            header('Location: ' . BASE_URL . "/{$this->lowerName}");
        }
        return $detail;
    }

    public function submit()
    {
        $data = $_POST;
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
            'act_code' => "required|unique_package:{$data['pkg_fiscal_year']},{$data['prg_code']},{$data['id']}",
        ]);

        $validation->setAliases([
            'pkg_fiscal_year' => 'Tahun Anggaran',
            'prg_code' => 'Kode Program',
            'act_code' => 'Kode Kegiatan',
        ]);

        $validation->setMessages([
            'required' => '<strong>:attribute</strong> harus diisi.',
            'act_code:unique_package' =>
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
}
