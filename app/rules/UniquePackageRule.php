<?php

namespace app\rules;
use PDO;
use Rakit\Validation\Rule;

class UniquePackageRule extends Rule
{
    protected $message = ':attribute :value has been used';

    protected $fillableParams = ['pkg_fiscal_year', 'prg_code', 'except'];

    protected $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    public function check($value): bool
    {
        // make sure required parameters exists
        $this->requireParameters(['pkg_fiscal_year', 'prg_code', 'except']);

        // getting parameters
        $pkg_fiscal_year = $this->parameter('pkg_fiscal_year');
        $prg_code = $this->parameter('prg_code');
        $except = $this->parameter('except');
        $key = $this->getAttribute()->getKey();

        // do query
        $query = "select count(*) as count from `apm_package` 
            where `{$key}` = :value 
            and `pkg_fiscal_year` = :pkg_fiscal_year
            and `prg_code` = :prg_code
            and `id` != :except";
        $stmt = $this->pdo->prepare($query);
        $stmt->bindParam(':value', $value);
        $stmt->bindParam(':pkg_fiscal_year', $pkg_fiscal_year);
        $stmt->bindParam(':prg_code', $prg_code);
        $stmt->bindParam(':except', $except);
        $stmt->execute();
        $data = $stmt->fetch(PDO::FETCH_ASSOC);

        // true for valid, false for invalid
        return intval($data['count']) === 0;
    }
}
