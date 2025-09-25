import { useDispatch, useSelector } from 'react-redux'
import { useNavigate } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import { RootState, AppDispatch } from '@store/index'
import { loginStart, loginSuccess, loginFailure, logout as logoutAction } from '@store/slices/authSlice'
import { authService } from '@services/api'

export function useAuth() {
  const dispatch = useDispatch<AppDispatch>()
  const navigate = useNavigate()
  const auth = useSelector((state: RootState) => state.auth)

  const loginMutation = useMutation({
    mutationFn: ({ email, password }: { email: string; password: string }) =>
      authService.login(email, password),
    onMutate: () => {
      dispatch(loginStart())
    },
    onSuccess: (response) => {
      dispatch(loginSuccess(response.data))
      navigate('/dashboard')
    },
    onError: () => {
      dispatch(loginFailure())
    },
  })

  const registerMutation = useMutation({
    mutationFn: (data: { email: string; password: string; name: string }) =>
      authService.register(data),
    onSuccess: (response) => {
      dispatch(loginSuccess(response.data))
      navigate('/dashboard')
    },
  })

  const logout = () => {
    dispatch(logoutAction())
    navigate('/login')
  }

  return {
    ...auth,
    login: loginMutation.mutate,
    register: registerMutation.mutate,
    logout,
    isLoggingIn: loginMutation.isPending,
    isRegistering: registerMutation.isPending,
  }
}