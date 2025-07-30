#!/bin/bash

if [ $# -ne 3 ] ; then
	echo 'Usage: '`basename $0`' <input file to be smoothed> <x FWHM size (mm)> <y FWHM size (mm)>';
	echo "Needs FSL and afni modules loaded"
	exit 1;
fi

# path to AFNI's nifti_tool
#NTPATH=$(dirname $(which nifti_tool))

#if [ "$NTPATH" = "" ] || [ "$FSLDIR" = "" ] ; then
#	echo "Needs AFNI and FSL modules loaded"
#	exit 1
#fi

# some variables
inputfile=`${FSLDIR}/bin/imglob -oneperimage $1`;
dirpart=`dirname $1`;                                           # path to file
filename=`basename ${inputfile}`                                # just file name plus extension
dataname=`${FSLDIR}/bin/remove_ext ${inputfile}`;               # path and file name minus extension
filebase=`${FSLDIR}/bin/remove_ext ${filename}`;                # file name minus extension

protofiles=$HOME/bin/GAUSSIAN

if [ ! -d $protofiles ] ; then
	echo "Cannot run as don't have $HOME/bin/GAUSSIAN folder"
	exit 1
elif [ ! -f ygauss.nii.gz ] ; then
	xsigma=`printf "0%s" $(echo "scale=6; $2/2.3548" | bc)`
	ysigma=`printf "0%s" $(echo "scale=6; $3/2.3548" | bc)`

	xpixdim=`$FSLDIR/bin/fslval $1 pixdim1 | awk '{print $1}'`
	ypixdim=`$FSLDIR/bin/fslval $1 pixdim2 | awk '{print $1}'`
	zpixdim=`$FSLDIR/bin/fslval $1 pixdim3 | awk '{print $1}'`

	afni nifti_tool -mod_hdr -prefix Xstrip.nii -infiles ${protofiles}/xstrip.nii -mod_field pixdim '-1.0 '${xpixdim}' '${ypixdim}' '${zpixdim}' 1.0 0.0 0.0 0.0'
	afni nifti_tool -mod_hdr -prefix Ystrip.nii -infiles ${protofiles}/ystrip.nii -mod_field pixdim '-1.0 '${xpixdim}' '${ypixdim}' '${zpixdim}' 1.0 0.0 0.0 0.0'


	$FSLDIR/bin/fslmaths Xstrip -s $xsigma xgauss -odt float
	$FSLDIR/bin/fslmaths Ystrip -s $ysigma ygauss -odt float
fi

$FSLDIR/bin/fslmaths $1 -kernel file xgauss -fmean foo
$FSLDIR/bin/fslmaths foo -kernel file ygauss -fmean ${dataname}_smoothed${2}${3}


/bin/rm foo.nii.gz
