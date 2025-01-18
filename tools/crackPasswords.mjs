import { passwordHash } from '../services/password/lib/index.mjs'
import { readFileSync, writeFileSync } from 'node:fs'

const passwordChars = '0123456789abcdefghijklmnopqrstuvwxyzABVCDEFGHIJKLMNOPQRSTUVWXYZ`¬!"£$%^&*()-_=+[{]};:\'#~\\|,<.>/?'

/*
 * Generate all possible combinations from a list of characters for a given length
 */
function * charCombinations (chars, minLength, maxLength) {
  chars = typeof chars === 'string' ? chars : ''
  minLength = parseInt(minLength) || 0
  maxLength = Math.max(parseInt(maxLength) || 0, minLength)

  // Generate for each word length
  for (let i = minLength; i <= maxLength; i++) {
    // Generate the first word for the password length by the repetition of first character.
    let word = (chars[0] || '').repeat(i)
    yield word

    // Generate other possible combinations for the word
    // Total combinations will be chars.length raised to power of word.length
    // Make iteration for all possible combinations
    for (let j = 1; j < Math.pow(chars.length, i); j++) {
      // Make iteration for all indices of the word
      for (let k = 0; k < i; k++) {
        // check if the current index char need to be flipped to the next char.
        if (!(j % Math.pow(chars.length, k))) {
          // Flip the current index char to the next.
          const charIndex = chars.indexOf(word[k]) + 1
          const char = chars[charIndex < chars.length ? charIndex : 0]
          word = word.substr(0, k) + char + word.substr(k + char.length)
        }
      }

      // Re-oder not neccesary but it makes the words are yeilded alphabetically on ascending order.
      // yield word.split('').reverse().join('')
      yield word
    }
  }
}

/*
 * Example:
 * List passwords of max length of 3
 */
let attempted = 0
const userdata = readFileSync('output/userPwHash.json')
const users = JSON.parse(userdata)
const hashes = {}
users.forEach((user) => {
  if (hashes[user.passwd]) {
    hashes[user.passwd].push(user.uid)
  } else {
    hashes[user.passwd] = [user.uid]
  }
})
const passwords = charCombinations(passwordChars, 2, 8)
const cracked = {}

let hash
let password
await processPassword()

async function processPassword () {
  let loop = true
  while (loop) {
    attempted++
    if (attempted % 10000 === 0) {
      console.log(attempted)
      loop = false
    }
    password = passwords.next()
    hash = passwordHash(password.value)
    if (hash) {
      if (hashes[hash]) {
        console.log('Got one: %s', password.value)
        cracked[hash] = {
          password: password.value,
          uids: hashes[hash]
        }
        writeFileSync('output/cracked.json', JSON.stringify(cracked))
      }
    // console.log('Password: %s, Hash: %s', password.value, hash)
    }
    if (password.done) {
      loop = false
    }
  }
  if (!password.done) {
    setImmediate(processPassword)
  }
}
