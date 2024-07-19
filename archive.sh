#!/bin/bash
. /home/grjsmith/utils/archive.config
output_tar="$backup_target_dir/$target_file_prefix$(date +%Y%m%d%H%M%S).tar.gz"

readarray -t files < <(find $backup_target_dir -maxdepth 1 -name "Obsidian_Vault_*" -type f)
# Test: echo "There are ${#files[@]} archive files, they are:"
#for i in ${files[@]}
#do
#    echo $i
#done
readarray -t old_files < <(find "$backup_target_dir" -maxdepth 1 -name "Obsidian_Vault_*" -type f -mmin +8640 | wc -l)
# Test: for i in ${old_files[@]}
#do
#    echo $i
#done
echo "There are ${old_files[@]} files older than 6 days"

# If there are any archive files or if any of the archive files are older then 6 days (-mmin +8640) then run the tar else exit.
if [ ${#files[@]} -eq 0 ] || [ ${old_files[@]} -gt 0 ]; then
    tar -czf "$output_tar" -C "$backup_source_dir" .
    echo "Backup completed: $output_tar"
else
    echo "No backup needed, there are ${#files[@]} files"
fi
