# PoSH-Passwords

This a a simple function, that I will be adding to over time to generate passwords using PowerShell utilising the Windows Pseudo Random Number Generator (PRNG) which is a function from the Windows Cryptographic Service Provider (CSP).  This is (more than) 'good enough' for most cases as without a hardware generator probably as good as Windows provides.

It was borne of frustration with a number of devices, platforms and applications not accepting specific charecters as input.  A number of platforms won't allow:

* Specific Charecters only (% $ \  \/ for instance)
* No numbers as the first charecter
* No symbols as the first charecter

This is created as PowerShell function that is simple to use.

Firstly import the function

`import-module .\password-functions.psm1`

Then call the function
`New-Password`

It will output (by default) a:  

* 16 charecter password
* At least one Upper Case and one Lower Case
* At least one number
* At least one simple symbol eg. `*!@#$.-+`

An example would be `P30ina5vUSfIaA+z`

## Additional Settings

### Need a number of passwords ?

If you need more than one add `-count` followed by a number

### Need a different length of password ?

If you need a different password length add `-length` followed by a number

### Need an easy to read password thats still complex ?

Add the `-readable` flag.   This takes out some of the similar charecters such as `oO` and `iI`, leaving the numbers.

### Need really strong passwords ?

Add the `-strong` flag.  This uses the full alpha, numeric and standard symbol set including the icky charecters that some systems dont like.
