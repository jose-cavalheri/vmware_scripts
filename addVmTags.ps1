# csv = hostname,category,bkp_tags_1,migration_tags
import-csv vmnames.csv -useculture | foreach{
$vmname = $_.hostname
$category = $_.category
$bkp_tags_1 = $_.bkp_tags_1
$migration_tags = $_.migration_tags

    Write-Host $vmname " - " $category  " - " $bkp_tags_1  " - " $migration_tags


    Try {
        #Assign Tag to VM = $bkp_tags_1 
        $GetVMTag = Get-Tag -Name $bkp_tags_1  -ErrorAction Stop
        Write-Host "$bkp_tags_1 tag found!"
        Get-VM $vmname | New-TagAssignment -Tag $GetVMTag
        Write-Host "Tag Assignment completed"
        
    } Catch {
    Write-Host "Tag name you entered not found, let's create one"
    $YesOrNo = Read-Host "Please confirm, if you would like to proceed further (Y/N)"
        if(($YesOrNo -eq 'y') -or ($YesOrNo -eq 'Y')){
            $uTagCatName = $category

        $GetVMTagCat = Get-TagCategory -Name $uTagCatName -ErrorAction Stop
        Write-Host "TagCategory found"
        $uNewTagName = $bkp_tags_1 
        New-Tag -Name $uNewTagName -Category $GetVMTagCat

        #Assign Tag to VM
        $GetVMTag = Get-Tag -Name $bkp_tags_1  -ErrorAction Stop
        Write-Host "$bkp_tags_1 tag found!"

        Get-VM $vmname | New-TagAssignment -Tag $GetVMTag
        Write-Host "Tag Assignment completed"
        }
    }

    Try {
        #Assign Tag to VM = $migration_tags
        $GetVMTag = Get-Tag -Name $migration_tags  -ErrorAction Stop
        Write-Host "$migration_tags tag found!"
        Get-VM $vmname | New-TagAssignment -Tag $GetVMTag
        Write-Host "Tag Assignment completed"
    } Catch {
        Write-Host "Tag name you entered not found, let's create one"
        $YesOrNo = Read-Host "Please confirm, if you would like to proceed further (Y/N)"
        if(($YesOrNo -eq 'y') -or ($YesOrNo -eq 'Y')){
                $uTagCatName = $category

            $GetVMTagCat = Get-TagCategory -Name $uTagCatName -ErrorAction Stop
            Write-Host "TagCategory found"
            $uNewTagName = $migration_tags
            New-Tag -Name $uNewTagName -Category $GetVMTagCat

            #Assign Tag to VM
            $GetVMTag = Get-Tag -Name $migration_tags -ErrorAction Stop
            Write-Host "$migration_tags tag found!"

            Get-VM $vmname | New-TagAssignment -Tag $GetVMTag
            Write-Host "Tag Assignment completed"

        }
        

    }

}
 Write-Host "List Completed"