! -*- mode: f90; -*-
! Copyright (C) 2005-2007 Nicole Riemer and Matthew West
! Licensed under the GNU General Public License version 2 or (at your
! option) any later version. See the file COPYING for details.
!
! Simulation with sedimentation kernel, fixed timestepping and hybrid array.

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

program run_constant_fix_hybrid
  
  use mod_bin
  use mod_array
  use mod_array_hybrid
  use mod_init_dist
  use mod_mc_fix_hybrid
  use mod_kernel_constant
  use mod_condensation
  use mod_environ
  use mod_material
  use mod_constants
  use mod_util
  
  ! species #1 is water, only for testing purposes

  integer, parameter :: MM = 10000   ! number of particles
  integer, parameter :: n_bin = 160  ! number of bins
  integer, parameter :: n_spec = 1   ! number of species
  integer, parameter :: n_loop = 1   ! number of loops
  integer, parameter :: scal = 3     ! scale factor for bins
  real*8, parameter :: v_min = 1d-24 ! minimum volume (m^3) for making grid
  real*8, parameter :: N_0 = 2d8     ! particle number concentration (#/m^3)
  real*8, parameter :: V_0 = 4.1886d-15 ! mean volume of initial
                                        ! distribution (m^3)
  
  real*8, parameter :: t_max = 480d0 ! total simulation time (seconds)
  real*8, parameter :: t_print = 60d0 ! interval between output (s)
  real*8, parameter :: t_state = 0d0 ! interval between state output (s)
  real*8, parameter :: t_progress = 1d0 ! interval between progress printing (s)
  real*8, parameter :: del_t = 1d0   ! timestep (s)
  
  integer M, M1, M2, i_loop, i
  real*8 V(MM,n_spec), dlnr
  type(bin_p) VH(n_bin)
  real*8 bin_v(n_bin), n_den(n_bin)
  real*8 bin_g(n_bin), bin_gs(n_bin,n_spec), vol_frac(n_spec)
  integer n_ini(n_bin), bin_n(n_bin), MH(n_bin)
  type(environ) :: env
  type(material) :: mat

  call init_hybrid(n_spec, MH, VH)
  
  call allocate_material(mat, n_spec)
  mat%i_water = 1
  mat%rho = (/ 1000d0 /)
  mat%nu = (/ 0 /)
  mat%eps = (/ 0d0 /)
  mat%M_w = (/ 18d-3 /)
  
  env%T = 288d0        ! (K)
  env%RH = 0.999d0     ! (1)
  env%p = 1d5          ! (Pa)
  env%dTdt = -0.01d0   ! (K s^{-1})
  
  open(30,file='out_constant_fix_hybrid.d')
  call print_header(n_loop, n_bin, n_spec,  &
       nint(t_max / t_print) + 1)
  ! call srand(17)
  call srand(time())
  do i_loop = 1,n_loop
     
     call make_bin_grid(n_bin, scal, v_min, bin_v, dlnr)
     call zero_v(MM,n_spec,V)
     
     ! initialize first distribution
     call init_exp(V_0, n_bin, bin_v, n_den)
     call dist_to_n(MM, dlnr, n_bin, bin_v, n_den, bin_n)
     vol_frac(1) = 1d0
     call compute_volumes(n_bin, n_spec, vol_frac, MM, 1,MM, &
          n_ini, bin_v, dlnr, V, M)
     
     env%V_comp = dble(M) / N_0
     call mc_fix_hybrid(MM, M, n_spec, V, n_bin, MH, VH, &
          bin_v, bin_g, bin_gs, bin_n, dlnr , &
          kernel_constant, t_max, t_print, t_state, t_progress ,del_t, &
          i_loop, env, mat)
     
  enddo
  
end program run_constant_fix_hybrid

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
