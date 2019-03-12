#!/usr/bin/perl
process_files ($base_path);

# Accepts one argument: the full path to a directory.
# Returns: A list of files that reside in that path.
sub process_files {
    my $path = "/Users/rojohn";

    opendir (DIR, $path)
        or die "Unable to open $path: $!";

    # We are just chaining the grep and map from
    # the previous example.
    # You'll see this often, so pay attention ;)
    # This is the same as:
    # LIST = map(EXP, grep(EXP, readdir()))
    my @files =
        # Third: Prepend the full path
        map { $path . '/' . $_ }
        # Second: take out '.' and '..'
        grep { !/^\.{1,2}$/ }
        # First: get all files
        readdir (DIR);

    closedir (DIR);

    for (@files) {
        if (-d $_) {
            # Add all of the new files from this directory
            # (and its subdirectories, and so on... if any)
            push @files, process_files ($_);

        } else {
            # Do whatever you want here =) .. if anything.
        }
    }
    # NOTE: we're returning the list of files
    return @files;
}


   for (@files) {
		print "$files[$_]\n";
   return @files;
   }
