CLANG_VERSION=$(build/soong/scripts/get_clang_version.py)
export LLVM_AOSP_PREBUILTS_VERSION="${CLANG_VERSION}"

# check to see if the supplied product is one we can build
function check_product()
{
    local T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree. Try setting TOP." >&2
        return
    fi
    if (echo -n $1 | grep -q -e "^aospb_") ; then
        AOSP_BUILD=$(echo -n $1 | sed -e 's/^aospb_//g')
    else
        AOSP_BUILD=
    fi
    export AOSP_BUILD

        TARGET_PRODUCT=$1 \
        TARGET_RELEASE=$2 \
        TARGET_BUILD_VARIANT= \
        TARGET_BUILD_TYPE= \
        TARGET_BUILD_APPS= \
        _get_build_var_cached TARGET_DEVICE > /dev/null
    # hide successful answers, but allow the errors to show
}

function brunch()
{
    breakfast $*
    if [ $? -eq 0 ]; then
        mka bacon
    else
        echo "No such item in brunch menu. Try 'breakfast'"
        return 1
    fi
    return $?
}

function breakfast()
{
    target=$1
    local variant=$2
    source ${ANDROID_BUILD_TOP}/vendor/aosp/vars/aosp_target_release

    if [ $# -eq 0 ]; then
        # No arguments, so let's have the full menu
        lunch
    else
        if [[ "$target" =~ -(user|userdebug|eng)$ ]]; then
            # A buildtype was specified, assume a full device name
            lunch $target
        else
            # This is probably just the AOSP model name
            if [ -z "$variant" ]; then
                variant="userdebug"
            fi

            lunch aospb_$target-$aosp_target_release-$variant
        fi
    fi
    return $?
}

alias bib=breakfast

function omnom()
{
    brunch $*
    eat
}

function cout()
{
    if [  "$OUT" ]; then
        cd $OUT
    else
        echo "Couldn't locate out directory.  Try setting OUT."
    fi
}

function mka() {
    m "$@"
}

function cmka() {
    if [ ! -z "$1" ]; then
        for i in "$@"; do
            case $i in
                bacon|otapackage|systemimage)
                    mka installclean
                    mka $i
                    ;;
                *)
                    mka clean-$i
                    mka $i
                    ;;
            esac
        done
    else
        mka clean
        mka
    fi
}

alias mmp='dopush mm'
alias mmmp='dopush mmm'
alias mmap='dopush mma'
alias mmmap='dopush mmma'
alias mkap='dopush mka'
alias cmkap='dopush cmka'

function fixup_common_out_dir() {
    common_out_dir=$(_get_build_var_cached OUT_DIR)/target/common
    target_device=$(_get_build_var_cached TARGET_DEVICE)
    common_target_out=common-${target_device}
    if [ ! -z $AOSP_FIXUP_COMMON_OUT ]; then
        if [ -d ${common_out_dir} ] && [ ! -L ${common_out_dir} ]; then
            mv ${common_out_dir} ${common_out_dir}-${target_device}
            ln -s ${common_target_out} ${common_out_dir}
        else
            [ -L ${common_out_dir} ] && rm ${common_out_dir}
            mkdir -p ${common_out_dir}-${target_device}
            ln -s ${common_target_out} ${common_out_dir}
        fi
    else
        [ -L ${common_out_dir} ] && rm ${common_out_dir}
        mkdir -p ${common_out_dir}
    fi
}
