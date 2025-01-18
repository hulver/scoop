import ffi from 'ffi-napi'

const libcrypt = ffi.Library('libcrypt', {
  crypt: ['string', ['string', 'string']]
})

const cleanSalt = (value) => {
  let salt = value.substring(0, 2)
  if (salt.length < 2) salt += salt
  salt = salt.substring(0, 2)
  return salt
}

const passwordHash = (password) => {
  if (password.length < 2) {
    throw new Error('Password too short (must be at least 2 characters)')
  }
  const salt = cleanSalt(password)

  const hash = libcrypt.crypt(password, salt)

  return (hash.substring(2, hash.length))
}

const comparePassword = (password, hash) => {
  const hashCompare = passwordHash(password)
  return (hash === hashCompare)
}

export { passwordHash, comparePassword }
