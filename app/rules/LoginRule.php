<?php
namespace app\rules;
use \PDO;
use Rakit\Validation\Rule;

class LoginRule extends Rule
{
    protected $message = '<strong>Username</strong> dan <strong>Password</strong> tidak cocok.';

    protected $fillableParams = ['usr_username'];

    protected $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    public function check($value): bool
    {
        // make sure required parameters exists
        $this->requireParameters(['usr_username']);

        // getting parameters
        $username = $this->parameter('usr_username');
        $password = $value;

        // do query
        $query =
            'select count(*) as count from `apm_user` where `usr_username` = :username and `usr_password` = :password';
        $stmt = $this->pdo->prepare($query);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $password);
        $stmt->execute();
        $data = $stmt->fetch(PDO::FETCH_ASSOC);

        // true for valid, false for invalid
        return intval($data['count']) !== 0;
    }
}
