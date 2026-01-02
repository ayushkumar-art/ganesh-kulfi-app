import at.favre.lib.crypto.bcrypt.BCrypt

fun main() {
    val password = "Retailer1234"
    val hash = BCrypt.withDefaults().hashToString(12, password.toCharArray())
    println("Password: $password")
    println("BCrypt Hash: $hash")
    println()
    println("SQL Update Command:")
    println("UPDATE app_user SET password_hash = '$hash' WHERE email = 'retailer@test.com';")
}
