import { NodeHtmlMarkdown } from 'node-html-markdown'

const nhm = new NodeHtmlMarkdown(
  /* options (optional) */ {},
  /* customTransformers (optional) */ undefined,
  /* customCodeBlockTranslators (optional) */ undefined
)

const macFile = (input) => {

}

const macYoutube = (input) => {
  console.log(input)
  let vidRef = ''
  if (input.match(/name="movie"/)) {
    vidRef = input.match(/.+value="https*:\/\/w*w*w*\.*youtube\.com\/v\/([\w-]+).+/i)
  } else {
    vidRef = input.match(/.*https*:\/\/w*w*w*\.*youtube\.com\/watch\?v=([\w-]+).*/i)
  }
  if (vidRef) {
    console.log('output: ', `<a href="https://www.youtube.com/watch?v=${vidRef[1]}">https://www.youtube.com/watch?v=${vidRef[1]}</a>`)
    return `<a href="https://www.youtube.com/watch?v=${vidRef[1]}">https://www.youtube.com/watch?v=${vidRef[1]}</a>`
  } else {
    return input
  }
}

const macSpoiler = (input) => {

}

const validMacros = [{ name: 'file', code: macFile },
  { name: 'youtube', code: macYoutube },
  { name: 'spoiler', code: macSpoiler }
]
const inValidMacros = []

const validMacro = (macro) => {
  let retval = false
  if (validMacros.find((element) => { return element.name === macro.name })) {
    retval = true
  } else {
    if (macro.name.length < 15) {
      if (!inValidMacros.includes(macro.name)) { inValidMacros.push(macro.name) }
    }
  }
  return retval
}

const macroName = (text) => {
  // $text =~ /^\s*(\S+)\s*(.*)/s;
  const splitName = /^\s*(\S+)\s*(.*)/s
  const name = text.match(splitName)
  const retval = {}
  if (name) {
    retval.isMacro = true
    retval.name = name[1]
    retval.arguments = name[2]
  } else {
    retval.isMacro = false
  }
  // console.log(retval)
  return retval
}

const processMacro = (macro) => {
  const macCode = validMacros.find((element) => { return element.name === macro.name }).code
  return macCode(macro.arguments)
}

const findMacros = /\(\((.*?)\)\)/sgi

// $text =~ s{\(\((.*?)\)\)}{ $S->_process_macro($1,$context) }sige;
const checkMacro = (targetText) => {
  const newTargetText = targetText.replace(findMacros, (match, $1) => {
    // Return the replacement leveraging the parameters.
    // console.log(match, $1)
    const macro = macroName($1)
    if (macro.isMacro) {
      if (validMacro(macro)) {
        return processMacro(macro)
      }
    }
    return `((${match}))`
  })
  return newTargetText
}

const convert = (html) => {
  return nhm.translate({ html: checkMacro(html) }).html
}

const returnInvalidMacros = () => {
  return inValidMacros
}

export { convert, returnInvalidMacros }
