#!/bin/bash

function load_tags() {
	git_tags=($(git ls-remote --tags https://github.com/${git_repo}.git | awk '{print $2}' | sed 's/refs\/tags\///g' | grep -v "{}" | grep "^v"))
}

function is_up_to_date() {
	if [ ${capedwarf_upstream_version} -gt ${capedwarf_local_version} ]; then
		is_up_to_date_r="false"
	else
		is_up_to_date_r="true"
	fi
}

function set_upstream_version() {
	upstream_version_file=https://raw.github.com/${git_repo}/${git_tag}/version.ini

	#set capedwarf_upstream_version & as_required
	source /dev/stdin <<< "$(curl -L -s ${upstream_version_file})"

}

function update_capedwarf() {
	curl -s -o ${cd_home}capedwarf-openshift.tar.gz -L https://github.com/${git_repo}/tarball/${git_tag}
	
	tar -C ${cd_home} -xzf ${cd_home}capedwarf-openshift.tar.gz
	rm -f ${cd_home}capedwarf-openshift.tar.gz
	if [ -d "${cd_home}capedwarf-modules" ]; then
		rm -rf "${cd_home}capedwarf-modules"
	fi

	downloaded_dir_name=$(ls ${cd_home} | grep ${git_repo_folder})
	mv "${cd_home}${downloaded_dir_name}" "${cd_home}capedwarf-modules"

	#transform
	source ${cd_transformer_script}
	cd_transformer
}

function check_requirements() {
	if [ -d "${as_required}" ]; then
		check_requirements_r="true"
	else
		echo "Check requirements: missing required ${as_required}"		
		check_requirements_r="false"
	fi
}

function random_pass_required_chars {
    rnd_pass=$(head -n 50 /dev/urandom|tr -dc "$+*@&"|fold -w 1 | head -n1)
    rnd_pass=${rnd_pass}$(head -n 50 /dev/urandom|tr -dc "a-np-z"|fold -w 1 | head -n1)
    rnd_pass=${rnd_pass}$(head -n 50 /dev/urandom|tr -dc "1-9"|fold -w 1 | head -n1)
    rnd_pass=${rnd_pass}$(head -n 50 /dev/urandom|tr -dc "A-NP-Z"|fold -w 1 | head -n1)
    printf "%s\n" "$rnd_pass"
}
