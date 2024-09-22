# decryption Threat actor script written for COIT11241 Subject
# Assignment 2
# Tevin Herath
# Acknowledgment: Some copntent of this script was generated using ChatGPT 
# ----------------------------------------------------------------

# Function to decrypt a file
function Decrypt-File {
    param (
        [string]$EncryptedFilePath,
        [string]$Password,
        [string]$OutputPath
    )

    # Read the encrypted file content (IV + encrypted data)
    $encryptedContent = [System.IO.File]::ReadAllBytes($EncryptedFilePath)

    # Extract the first 16 bytes as the IV (AES uses a 16-byte IV)
    $iv = $encryptedContent[0..15]

    # Extract the remaining bytes as the encrypted data
    $encryptedData = $encryptedContent[16..($encryptedContent.Length - 1)]

    # Create AES instance and hash the password to derive the key
    $aes = New-Object System.Security.Cryptography.AesManaged
    $aes.KeySize = 128

    # Hash the password and use the first 16 bytes for the AES key
    $hashedPassword = Get-Hash $Password
    $aes.Key = $hashedPassword[0..15]

    # Set the IV for decryption
    $aes.IV = $iv

    # Create decryptor and memory stream for decryption
    $decryptor = $aes.CreateDecryptor($aes.Key, $aes.IV)
    $memoryStream = New-Object System.IO.MemoryStream
    $cryptoStream = New-Object System.Security.Cryptography.CryptoStream($memoryStream, $decryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)

    # Decrypt the file content
    $cryptoStream.Write($encryptedData, 0, $encryptedData.Length)
    $cryptoStream.Close()

    # Write the decrypted content to the output file
    $decryptedContent = $memoryStream.ToArray()
    [System.IO.File]::WriteAllBytes($OutputPath, $decryptedContent)

    Write-Host "File decrypted and saved at: $OutputPath"
}

# Function to hash the password using SHA256 (returns 32 bytes)
function Get-Hash {
    param ([string]$InputString)
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    return $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($InputString))
}

# Example usage
$encryptedFile = Read-Host "Enter File you want to decrypt"
$password = Read-Host "Enter Decryption Password"
$outputDecryptedFile = $encryptedFile.Substring(0, $encryptedFile.Length - 4)

Decrypt-File -EncryptedFilePath $encryptedFile -Password $password -OutputPath $outputDecryptedFile

Remove-Item $encryptedFile