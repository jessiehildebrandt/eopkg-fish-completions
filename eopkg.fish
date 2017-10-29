##############################
# Fish Completions for Eopkg #
# Jessie Hildebrandt         #
##############################

#############################
# Package Listing Functions #
#############################

# List installed packages
function __fish_eopkg_print_installed --description 'Print out a list of installed packages from eopkg'

	# Set up cache directory
	if test -z "$XDG_CACHE_HOME"
		set XDG_CACHE_HOME $HOME/.cache
	end
	mkdir -m 700 -p $XDG_CACHE_HOME

	# Set up cache file for installed packages
	set -l cache_file $XDG_CACHE_HOME/.eopkg-installed-cache.$USER

	# Check for the cache file
	if test -f $cache_file

		# Read contents of the cache file
		cat $cache_file

		# Check age and return prematurely if its still young enough
		set -l age (math (date +%s) - (stat -c '%Y' $cache_file))
		set -l max_age 21600 # Max age - 6 hours
		if test $age -lt $max_age
			return
		end

	end

	# Pipe eopkg results into the cache file, updating it
	eopkg list-installed -N | grep --color=never -o '^\S*' > $cache_file &

	return

end

# List available packages
function __fish_eopkg_print_available --description 'Print out a list of available packages from eopkg'

	# Set up cache directory
	if test -z "$XDG_CACHE_HOME"
		set XDG_CACHE_HOME $HOME/.cache
	end
	mkdir -m 700 -p $XDG_CACHE_HOME

	# Set up cache file for available packages
	set -l cache_file $XDG_CACHE_HOME/.eopkg-available-cache.$USER

	# Check for the cache file
	if test -f $cache_file

		# Read contents of the cache file
		cat $cache_file

		# Check age and return prematurely if its still young enough
		set -l age (math (date +%s) - (stat -c '%Y' $cache_file))
		set -l max_age 21600 # Max age - 6 hours
		if test $age -lt $max_age
			return
		end

	end

	# Pipe eopkg results into the cache file, updating it
	eopkg list-available -N | grep --color=never -o '^\S*' > $cache_file &

	return


end

####################
# Helper Functions #
####################

# Check for subcommand entry
function __fish_eopkg_no_subcommand --description 'Test if eopkg has yet to be given the subcommand'
	for cmd in (commandline -opc)
		if contains -- $cmd add-repo blame build check clean configure-pending delete-cache delta disable-repo emerge enable-repo fetch help history index info install list-available list-components list-installed list-newest list-pending list-repo list-sources list-upgrades rebuild-db remove remove-repo search search-file update-repo upgrade
			return 1
		end
	end
	return 0
end

# Check for specific subcommand
function __fish_eopkg_check_subcommand --description 'Test if the provided eopkg subcommand has been given'
	for cmd in (commandline -opc)
		if contains -- $cmd $argv
			return 0
		end
	end
	return 1
end

# Check if installed package autocompletion is needed
function __fish_eopkg_use_installed --description 'Test if eopkg command should have installed packages as potential completion'
	for cmd in (commandline -opc)
		if contains -- $cmd contains remove
			return 0
		end
	end
	return 1
end

# Check if available package autocompletion is needed
function __fish_eopkg_use_available --description 'Test if eopkg command should have available packages as potential completion'
	for cmd in (commandline -opc)
		if contains -- $cmd contains fetch info install search
			return 0
		end
	end
	return 1
end

##########################
# Completion Definitions #
##########################

# Package autocompletions
complete -c eopkg -n '__fish_eopkg_use_installed' -a '(__fish_eopkg_print_installed)' --description 'Installed package'
complete -c eopkg -n '__fish_eopkg_use_available' -a '(__fish_eopkg_print_available)' --description 'Available package'

# Universal help/version options
complete -c eopkg -s h -l help --description 'Display help and exit'
complete -c eopkg -l version --description 'Show version number and exit'

# General options
complete -c eopkg -s D -l destdir -r --description 'System root for eopkg commands'
complete -c eopkg -s y -l yes-all --description 'Assume yes in all yes/no queries'
complete -c eopkg -s u -l username
complete -c eopkg -s p -l password
complete -c eopkg -s L -l bandwidth-limit -r --description 'Limit bandwidth usage to specified KB/s'
complete -c eopkg -s v -l verbose
complete -c eopkg -s d -l debug
complete -c eopkg -s N -l no-color

# Subcommands
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'add-repo' --description 'Add a repository'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'blame' --description 'Information about package owner and release'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'build' --description 'Build eopkg packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'check' --description 'Verify installation'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'clean' --description 'Clean stale locks'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'configure-pending' --description 'Configure pending packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'delete-cache' --description 'Delete cache files'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'delta' --description 'Creates delta packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'disable-repo' --description 'Disable repository'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'emerge' --description 'Build and install eopkg source packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'enable-repo' --description 'Enable repository'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'fetch' --description 'Fetch a package'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'help' --description 'Prints help for given commands'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'history' --description 'History of pisi operations'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'index' --description 'Index eopkg files in a given directory'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'info' --description 'Display package information'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'install' --description 'Install eopkg packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'list-available' --description 'List available packages in repositories'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'list-components' --description 'List available components'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'list-installed' --description 'List all installed packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'list-newest' --description 'List newest packages in repositories'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'list-pending' --description 'List pending packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'list-repo' --description 'List repositories'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'list-sources' --description 'List available sources'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'list-upgrades' --description 'List packages to be upgraded'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'rebuild-db' --description 'Rebuild databases'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'remove' --description 'Remove eopkg packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'remove-repo' --description 'Remove repositories'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'search' --description 'Search packages'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'search-file' --description 'Search for a file'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'update-repo' --description 'Update repository database'
complete -f -n '__fish_eopkg_no_subcommand' -c eopkg -a 'upgrade' --description 'Upgrade eopkg packages'

##########################
# Subcommand Completions #
##########################

# Add-repo options
complete -f -n '__fish_eopkg_check_subcommand add-repo' -c eopkg -l ignore-check --description 'Ignore repo distribution check'
complete -f -n '__fish_eopkg_check_subcommand add-repo' -c eopkg -l no-fetch --description 'Does not fetch repo index'
complete -f -n '__fish_eopkg_check_subcommand add-repo' -c eopkg -l at -r --description 'Add repo at given position (0 is first'

# Blame options
complete -f -n '__fish_eopkg_check_subcommand blame' -c eopkg -s r -l release -r --description 'Blame for the given release'
complete -f -n '__fish_eopkg_check_subcommand blame' -c eopkg -s a -l all --description 'Blame for all of the releases'

# Build options
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l fetch --description 'Break build after fetching source'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l unpack --description 'Break build after unpacking, checking, and patching'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l setup --description 'Break build after running configure setup'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l build --description 'Break build after running compile step'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l check --description 'Break build after running check step'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l install --description 'Break build after running install step'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l package --description 'Create eopkg package'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -s q -l quiet --description 'Run pisi build without printing extra info'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l ignore-dependency --description 'Do not take dependencies into account'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -s O -l output-dir -r --description 'Output directory for produced packages'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l ignore-action-errors --description 'Bypass errors from ActionsAPI'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l ignore-safety --description 'Bypass safety switch'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l ignore-check --description 'Bypass testing step'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l create-static --description 'Create a static package'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -s F -l package-format -r --description 'Create a package with the given format'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l use-quilt --description 'Use quilt patch instead of GNU patch'
complete -f -n '__fish_eopkg_check_subcommand build' -c eopkg -l ignore-sandbox --description 'Do not constrain process inside build folder'

# Check options
complete -f -n '__fish_eopkg_check_subcommand check' -c eopkg -s c -l component -r --description 'Check packages under given component'
complete -f -n '__fish_eopkg_check_subcommand check' -c eopkg -l config --description 'Checks only changed config files'

# Clean options
# None

# Configure-pending options
complete -f -n '__fish_eopkg_check_subcommand configure-pending' -c eopkg -l ignore-dependency --description 'Do not take dependencies into account'
complete -f -n '__fish_eopkg_check_subcommand configure-pending' -c eopkg -l ignore-comar --description 'Bypass comar configuration agent'
complete -f -n '__fish_eopkg_check_subcommand configure-pending' -c eopkg -l ignore-safety --description 'Bypass safety switch'
complete -f -n '__fish_eopkg_check_subcommand configure-pending' -c eopkg -s n -l dry-run --description 'Do not perform any action'

# Delete-cache options
# None

# Delta options
complete -f -n '__fish_eopkg_check_subcommand delta' -c eopkg -s t -l newest-package -r --description 'Use arg as new package'
complete -f -n '__fish_eopkg_check_subcommand delta' -c eopkg -s O -l output-dir -r --description 'Output directory for produced packages'
complete -f -n '__fish_eopkg_check_subcommand delta' -c eopkg -s F -l package-format -r --description 'Create a package with the given format'

# Disable-repo options
# None

# Emerge options
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -s q -l quiet --description 'Run pisi build without printing extra info'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l ignore-dependency --description 'Do not take dependencies into account'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -s O -l output-dir -r --description 'Output directory for produced packages'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l ignore-action-errors --description 'Bypass errors from ActionsAPI'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l ignore-safety --description 'Bypass safety switch'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l ignore-check --description 'Bypass testing step'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l create-static --description 'Create a static package'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -s F -l package-format -r --description 'Create a package with the given format'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l use-quilt --description 'Use quilt patch instead of GNU patch'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l ignore-sandbox --description 'Do not constrain process inside build folder'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l ignore-file-conflicts --description 'Ignore file conflicts'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l ignore-package-conflicts --description 'Ignore package conflicts'
complete -f -n '__fish_eopkg_check_subcommand emerge' -c eopkg -l ignore-comar --description 'Bypass comar configuration agent'

# Enable-repo options
# None

# Fetch options
complete -f -n '__fish_eopkg_check_subcommand fetch' -c eopkg -s o -l output-dir --description 'Output directory for fetched packages'

# Help options
# None

# History options
complete -f -n '__fish_eopkg_check_subcommand history' -c eopkg -s l -l last -r --description 'Output only the last n operations'
complete -f -n '__fish_eopkg_check_subcommand history' -c eopkg -s s -l snapshot --description 'Take snapshot of the current system'
complete -f -n '__fish_eopkg_check_subcommand history' -c eopkg -s t -l takeback -r --description 'Takeback to the original state afterwards'

# Index options
complete -f -n '__fish_eopkg_check_subcommand index' -c eopkg -s a -l absolute-urls --description 'Store absolute links for indexed files'
complete -f -n '__fish_eopkg_check_subcommand index' -c eopkg -s o -l output --description 'Index output file'
complete -f -n '__fish_eopkg_check_subcommand index' -c eopkg -l compression-types -r --description 'List of compression types for index'
complete -f -n '__fish_eopkg_check_subcommand index' -c eopkg -l skip-sources --description 'Do not index eopkg spec files'
complete -f -n '__fish_eopkg_check_subcommand index' -c eopkg -l skip-signing --description 'Do not sign index'

# Info options
complete -f -n '__fish_eopkg_check_subcommand info' -c eopkg -s f -l files --description 'Show a list of package files'
complete -f -n '__fish_eopkg_check_subcommand info' -c eopkg -s c -l component -r --description 'Info about the given component'
complete -f -n '__fish_eopkg_check_subcommand info' -c eopkg -s F -l files-path --description 'Show only paths'
complete -f -n '__fish_eopkg_check_subcommand info' -c eopkg -s s -l short --description 'Do not show details'
complete -f -n '__fish_eopkg_check_subcommand info' -c eopkg -l xml --description 'Output in XML format'

# Install options
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -l ignore-dependency --description 'Do not take dependencies into account'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -l ignore-comar --description 'Bypass comar configuration agent'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -l ignore-safety --description 'Bypass safety switch'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -s n -l dry-run --description 'Do not perform any action'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -l reinstall --description 'Reinstall already-installed packages'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -l ignore-check --description 'Skip distro and arch checks'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -l ignore-file-conflicts --description 'Ignore file conflicts'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -l ignore-package-conflicts --description 'Ignore package conflicts'
complete -f -n '__fish_eopkg_check_subcommand install' -c eokpg -s c -l component -r --description 'Install component and underlying packages'
complete -f -n '__fish_eopkg_check_subcommand install' -c eokpg -s r -l repository -r --description 'Install from provided repo'
complete -f -n '__fish_eopkg_check_subcommand install' -c eokpg -s f -l fetch-only -r --description 'Fetch but do not install'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -s x -l exclude -r --description 'Exclude packages that match pattern'
complete -f -n '__fish_eopkg_check_subcommand install' -c eopkg -l exclude-from -r --description 'Exclude packages matching pattern in file'

# List-available options
complete -f -n '__fish_eopkg_check_subcommand list-available' -c eopkg -s l -l long --description 'Show in long format'
complete -f -n '__fish_eopkg_check_subcommand list-available' -c eopkg -s c -l component -r --description 'List packages in component'
complete -f -n '__fish_eopkg_check_subcommand list-available' -c eopkg -s U -l uninstalled --description 'Show uninstalled packages only'

# List-components options
complete -f -n '__fish_eopkg_check_subcommand list-components' -c eopkg -s l -l long --description 'Show in long format'
complete -f -n '__fish_eopkg_check_subcommand list-components' -c eopkg -s r -l repository -r --description 'Name of source or package repo'

# List-installed options
complete -f -n '__fish_eopkg_check_subcommand list-installed' -c eopkg -s b -l with-build-host --description 'List packages built by given host'
complete -f -n '__fish_eopkg_check_subcommand list-installed' -c eopkg -s l -l long --description 'Show in long format'
complete -f -n '__fish_eopkg_check_subcommand list-installed' -c eopkg -s r -l repository -r --description 'Name of source or package repo'
complete -f -n '__fish_eopkg_check_subcommand list-installed' -c eopkg -s i -l install-info --description 'Show detailed install info'

# List-newest options
complete -f -n '__fish_eopkg_check_subcommand list-newest' -c eopkg -s s -l since -r --description 'List packages added after date'
complete -f -n '__fish_eopkg_check_subcommand list-newest' -c eopkg -s l -l last -r --description 'List packages added before nth prev. update'

# List-pending options
# None

# List-repo options
# None

# List-sources options
complete -f -n '__fish_eopkg_check_subcommand list-sources' -c eopkg -s l -l long --description 'Show in long format'

# List-upgrades options
complete -f -n '__fish_eopkg_check_subcommand list-upgrades' -c eopkg -s l -l long --description 'Show in long format'
complete -f -n '__fish_eopkg_check_subcommand list-upgrades' -c eopkg -s c -l component -r --description 'List upgradable packages under component'
complete -f -n '__fish_eopkg_check_subcommand list-upgrades' -c eopkg -s i -l install-info --description 'Show detailed install info'

# Rebuild-db options
complete -f -n '__fish_eopkg_check_subcommand rebuild-db' -c eopkg -s f -l files --description 'Rebuild files database'

# Remove options
complete -f -n '__fish_eopkg_check_subcommand remove' -c eopkg -l ignore-dependency --description 'Do not take dependencies into account'
complete -f -n '__fish_eopkg_check_subcommand remove' -c eopkg -l ignore-comar --description 'Bypass comar configuration agent'
complete -f -n '__fish_eopkg_check_subcommand remove' -c eopkg -l ignore-safety --description 'Bypass safety switch'
complete -f -n '__fish_eopkg_check_subcommand remove' -c eopkg -s n -l dry-run --description 'Do not perform any action'
complete -f -n '__fish_eopkg_check_subcommand remove' -c eopkg -l purge --description 'Remove package and all config files'
complete -f -n '__fish_eopkg_check_subcommand remove' -c eokpg -s c -l component -r --description 'Remove component and underlying packages'

# Remove-repo options
# None

# Search options
complete -f -n '__fish_eopkg_check_subcommand search' -c eokpg -s l -l language -r --description 'Summary and description language'
complete -f -n '__fish_eopkg_check_subcommand search' -c eokpg -s r -l repository -r --description 'Name of source or package repo'
complete -f -n '__fish_eopkg_check_subcommand search' -c eokpg -s i -l installdb --description 'Search in installdb'
complete -f -n '__fish_eopkg_check_subcommand search' -c eokpg -s s -l sourcedb --description 'Search in sourcedb'
complete -f -n '__fish_eopkg_check_subcommand search' -c eokpg -l name --description 'Search in the package name'
complete -f -n '__fish_eopkg_check_subcommand search' -c eokpg -l summary --description 'Search in the package summary'
complete -f -n '__fish_eopkg_check_subcommand search' -c eokpg -l description --description 'Search in the package description'

# Search-file options
complete -f -n '__fish_eopkg_check_subcommand search-file' -c eokpg -s l -l long --description 'Show in long format'
complete -f -n '__fish_eopkg_check_subcommand search-file' -c eokpg -s q -l quiet --description 'Show only package name'

# Update-repo options
complete -f -n '__fish_eopkg_check_subcommand update-repo' -c eokpg

# Upgrade options
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -l ignore-dependency --description 'Do not take dependencies into account'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -l ignore-comar --description 'Bypass comar configuration agent'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -l ignore-safety --description 'Bypass safety switch'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -s n -l dry-run --description 'Do not perform any action'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -l security-only --description 'Install security-updates only'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -s b -l bypass-update-repo --description 'Do not update repositories'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -l ignore-file-conflicts --description 'Ignore file conflicts'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -l ignore-package-conflicts --description 'Ignore package conflicts'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -s c -l component -r --description 'Upgrade component and underlying packages'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -s r -l repository -r --description 'Name of source or package repo'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -s f -l fetch-only --description 'Fetch upgrades but do not install'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -s x -l exclude -r --description 'Exclude packages that match pattern'
complete -f -n '__fish_eopkg_check_subcommand upgrade' -c eokpg -l exclude-from -r --description 'Exclude packages matching pattern in file'
