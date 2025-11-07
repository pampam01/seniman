import { supabase } from '@/lib/supabase/client';

export async function signUp(email: string, password: string, userData: {
  firstName: string;
  lastName: string;
  userType: 'seniman' | 'klien';
}) {
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        first_name: userData.firstName,
        last_name: userData.lastName,
        user_type: userData.userType,
      },
    },
  });

  if (authError) throw authError;

  if (authData.user) {
    const { error: userError } = await supabase.from('users').insert({
      id: authData.user.id,
      email: authData.user.email,
      first_name: userData.firstName,
      last_name: userData.lastName,
      user_type: userData.userType,
      is_verified: false,
    });

    if (userError) throw userError;
  }

  return authData;
}

export async function signIn(email: string, password: string) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) throw error;
  return data;
}

export async function signOut() {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}

export async function getCurrentUser() {
  const { data: { user }, error } = await supabase.auth.getUser();

  if (error) throw error;
  if (!user) return null;

  const { data: userData, error: userError } = await supabase
    .from('users')
    .select('*')
    .eq('id', user.id)
    .maybeSingle();

  if (userError) throw userError;
  return userData;
}

export async function resetPassword(email: string) {
  const { error } = await supabase.auth.resetPasswordForEmail(email, {
    redirectTo: `${window.location.origin}/auth/reset-password`,
  });

  if (error) throw error;
}

export async function updatePassword(newPassword: string) {
  const { error } = await supabase.auth.updateUser({
    password: newPassword,
  });

  if (error) throw error;
}
