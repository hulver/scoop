import test from 'node:test'
import assert from 'node:assert'
import { passwordHash, comparePassword } from '../lib/index.js'

test("Known hash matches", () => {
  const calcHash = passwordHash("password")
  const expectedValue = "pAq5PwY/QQM"
  assert.deepStrictEqual(expectedValue, calcHash)
})

test("Long password hash", () => {
  const calcHash = passwordHash("passwordasdadasdasasdasdaasd")
  const expectedValue = "pAq5PwY/QQM"
  assert.deepStrictEqual(expectedValue, calcHash)
})

test("Compare 'password'", () => {
  const comparePw = 'password'
  const compareHash = "pAq5PwY/QQM"
  assert.deepStrictEqual(comparePassword(comparePw, compareHash), true)
})

test("Compare '12345678'", () => {
  const comparePw = '12345678'
  const compareHash = "yJ.Of/NQ.Pk"
  assert.deepStrictEqual(comparePassword(comparePw, compareHash), true)
})

test("Compare '1234567890'", () => {
  const comparePw = '1234567890'
  const compareHash = "yJ.Of/NQ.Pk"
  assert.deepStrictEqual(comparePassword(comparePw, compareHash), true)
})

test("Compare '!\"£$%^&*'", () => {
  const calcHash = passwordHash('!"£$%^&*')
  const compareHash = ""
  assert.deepStrictEqual(calcHash, compareHash, true)
})

test("Compare 'xxxx!'", () => {
  const calcHash = passwordHash('xxxx!')
  const compareHash = "bLhEtqwSMmc"
  assert.deepStrictEqual(calcHash, compareHash, true)
})

test("Compare 'pass'", () => {
  const calcHash = passwordHash('pass')
  const compareHash = "uONM/HSu9pM"
  assert.deepStrictEqual(calcHash, compareHash, true)

})
