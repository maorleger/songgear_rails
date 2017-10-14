import Elm from '../Main';

document.addEventListener('turbolinks:load', () => {
  const target = document.getElementById('elm-main')

  if (target) {
    Elm.Main.embed(target, { songId: target.dataset.songId })
  }
})
