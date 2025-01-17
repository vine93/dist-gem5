#! /bin/bash

#
# Copyright (c) 2015 ARM Limited
# All rights reserved
#
# The license below extends only to copyright in the software and shall
# not be construed as granting a license to any other intellectual
# property including but not limited to intellectual property relating
# to a hardware implementation of the functionality of the software
# licensed hereunder.  You may use the software subject to the license
# terms below provided that you ensure that this notice is replicated
# unmodified and in its entirety in all distributions of the software,
# modified or unmodified, in source code or in binary form.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met: redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer;
# redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution;
# neither the name of the copyright holders nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Authors: Gabor Dozsa
#
#
# This is an example script to start a dist gem5 simulations using
# two AArch64 systems. It is also uses the example
# dist gem5 bootscript util/dist/test/simple_bootscript.rcS that will
# run the linux ping command to check if we can see the peer system
# connected via the simulated Ethernet link.

GEM5_DIR=$(pwd)/$(dirname $0)/../../..

IMG=$M5_PATH/disks/aarch64-ubuntu-trusty-headless.img
VMLINUX=$M5_PATH/binaries/vmlinux.aarch64.20140821
DTB=$M5_PATH/binaries/vexpress.aarch64.20140821.dtb

FS_CONFIG=$GEM5_DIR/configs/example/fs.py
SW_CONFIG=$GEM5_DIR/configs/dist/sw.py
GEM5_EXE=$GEM5_DIR/build/ARM/gem5.opt

BOOT_SCRIPT=$GEM5_DIR/util/dist/test/warmup.4GB.rcS
GEM5_DIST_SH=$GEM5_DIR/util/dist/gem5-dist.sh

DEBUG_FLAGS="--debug-flags=DistEthernet,Ethernet,WorkItems,TimingIdle,CacheFlush"
#CHKPT_RESTORE="-r1"
CKPTDIR=$(pwd)
RUNDIR=$(pwd)/rundir
NNODES=3

$GEM5_DIST_SH -n $NNODES                                                     \
              -x $GEM5_EXE                                                   \
              -s $SW_CONFIG                                                  \
              -f $FS_CONFIG                                                  \
              --m5-args                                                      \
                 $DEBUG_FLAGS                                                \
              --fs-args                                                      \
                  --cpu-type=TimingSimpleCPU                                 \
		  --num-cpus=4                                               \
                  --machine-type=VExpress_EMM64                              \
                  --disk-image=$IMG                                          \
                  --kernel=$VMLINUX                                          \
                  --dtb-filename=$DTB                                        \
                  --script=$BOOT_SCRIPT                                      \
                  --l1d_size=32kB					     \
                  --l1i_size=32kB					     \
		  --l2_size=256kB  					     \
		  --l3_size=16MB  					     \
		  --l1d_assoc=2    						\
		  --l1i_assoc=2							\
		  --l2_assoc=4							\
		  --l3cache							\
		  --privateL2cache						\
		  --caches                                                   \ 
              --cf-args				  			     \
		  --$CHKPT_RESTORE						\
	          --dist-sync-start=1000000000t                               

#	      -c $CKPTDIR						     \
#	      -r $RUNDIR						     \


