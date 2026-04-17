<?php
$host     = getenv('MYSQL_HOST');
$database = getenv('MYSQL_DATABASE');
$user     = getenv('MYSQL_USER');
$password = getenv('MYSQLCONNSTR_MySQLConnection') ? parse_str(str_replace(';', '&', getenv('MYSQLCONNSTR_MySQLConnection')), $parts) : null;

// Extraer password del connection string de Azure
$connStr = getenv('MYSQLCONNSTR_MySQLConnection') ?: '';
preg_match('/Pwd=([^;]+)/', $connStr, $matches);
$password = $matches[1] ?? '';

echo "<h2>Web App - Arquitectura de Nube</h2>";
echo "<p><strong>Host:</strong> " . htmlspecialchars($host ?: 'no configurado') . "</p>";
echo "<p><strong>Database:</strong> " . htmlspecialchars($database ?: 'no configurado') . "</p>";
echo "<p><strong>User:</strong> " . htmlspecialchars($user ?: 'no configurado') . "</p>";
echo "<hr>";

if (!$host || !$user) {
    echo "<p style='color:orange;'>Variables de entorno no configuradas. Verifica App Settings en Azure.</p>";
    exit;
}

try {
    $pdo = new PDO(
        "mysql:host={$host};dbname={$database};port=3306",
        $user,
        $password,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::MYSQL_ATTR_SSL_CA => '/home/site/wwwroot/DigiCertGlobalRootCA.crt.pem',
            PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
        ]
    );
    echo "<p style='color:green;'>Conexion a MySQL exitosa.</p>";

    $stmt = $pdo->query("SELECT VERSION() AS version");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "<p><strong>Version MySQL:</strong> " . htmlspecialchars($row['version']) . "</p>";

    $stmt = $pdo->query("SHOW DATABASES");
    echo "<h3>Bases de datos:</h3><ul>";
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "<li>" . htmlspecialchars($row['Database']) . "</li>";
    }
    echo "</ul>";

} catch (PDOException $e) {
    echo "<p style='color:red;'>Error de conexion: " . htmlspecialchars($e->getMessage()) . "</p>";
}
?>
