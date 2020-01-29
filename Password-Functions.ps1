Function New-Password
{
<#
.SYNOPSIS
Creates a password using a pretty random method.  Good enough for most cases.

.DESCRIPTION
Creates a password using a pretty random method using the Windows CryptoAPI.  Good enough for most cases.

.PARAMETER Length
Length of passwords generated.  Default is 16

.PARAMETER Count
Number of passwords to generate.  Default is 1

.PARAMETER Strong
Generate passwords containing Upper, Lower, Numbers and complex Symbols. Not default

.PARAMETER Readable
Generate passwords containing Upper, Lower, Numbers and simple Symbols. Not default

.EXAMPLE
New-Password -Length 16
-Outputs one password using simple case, 16 charecters wide

New-Password -Length 20 -Count 20 -Readable
-Outputs twenty passwords, 20 charecters wide using readable format and symbols

.NOTES
This uses the WIndows System.Security.Cryptography.RNGCryptoServiceProvider method which provides pretty good randomness.
#>
Param
    (
        [int]$Length = 16,
        [int]$Count = 1,
        [switch]$Strong,
        [switch]$Readable
    )

Begin
    {
        #Define strings uses for generation
        $Alphas = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        $Numbers = "1234567890"
        $Symbols = $Numbers + "*!@#$.-+"
        $MoreSymbols = $Symbols + "%^&=()_{}|[]\:;<>?,/~"
                
        if ($Strong -eq $true)
        {
            [string]$charSet = $Alphas + $Numbers + $MoreSymbols
        }
        elseif ($Readable -eq $true)
        {
            [string]$charSet = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ" + $Numbers + $Symbols
        }
        else 
        {
            [string]$charSet = $Alphas + $Numbers + $Symbols
        }
        $Passwords = @()
    }
Process 
    {
        for ($Counter = 1;$Counter -le $Count; $Counter++)
        {
            $bytes = New-Object "System.Byte[]" $Length
            $rnd = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
            $rnd.GetBytes($bytes)
            $result = ""

            # Get the first charecter as an alpha only.   There are a lot of platforms and applications that only support this.
            $i=0
            $result += $Alphas[ $bytes[$i] % $Alphas.Length]

            # Now use the specified set for the rest
            for ( $i=1; $i -lt $Length; $i++)
                {
                    $result += $charSet[ $bytes[$i] % $charSet.Length]
                }

            #Check for uniqueness
            if ($result -cmatch "(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W){1,$Length}" )
                #Must have                          
                                    #^0-9
                                                #^a-z
                                                            #^A-Z
                                                                    #^Symbol
                                                                            #^No adjacency
                {
                #Set password to the result
                $Passwords += $result
                }
            else {
                #If it fails the match then run again by decrementing the counter
                #Forcing randomness again....
                $Counter--
                }
                
        }
              
    }
End   
    {  
        #Output only
        Return $Passwords
    }
}