$(document).ready(function () {
  /* Sidebar Active Tree Menu */
  $('.active-child')
    .closest('.has-treeview')
    .addClass('menu-open')
    .children()
    .addClass('active text-warning')

  $.fn.bstooltip = $.fn.tooltip.noConflict()
  $('[data-toggle="tooltip"]').bstooltip()
})

/**
 * @description fungsi ini untuk menampilkan flash data
 * @function flash()
 * @param {string} title
 * @param {string} icon
 */
let flash = (title, icon) => {
  Swal.fire({
    toast: true,
    position: 'top',
    icon: icon,
    title: title,
    showConfirmButton: false,
    timer: 3000,
  })
}

/**
 * @description fungsi ini untuk menampilkan error form validation
 * @function showErrorMessage()
 * @param {string} id is field id
 * @param {string} message is error message
 */
let showErrorMessage = (id, message) => {
  $(`#${id}`).addClass('is-invalid').next().html(message)
}

/**
 * @description fungsi ini untuk clear error form validation
 * @function clearErrorMessage()
 */
let clearErrorMessage = () => {
  // Todo: clear error message
  $('.form-control, .custom-select')
    .removeClass('is-invalid')
    .next('.invalid-feedback')
    .html('')
}

/**
 * @description fungsi ini menampilkan tooltip pada form input
 * @function formTooltip
 *
 * @param {string} id id field input
 * @param {string} color warna background tooltip - menggunakan Bootstrap color
 * @param {string} placement posisi tooltip - auto|top|right|bottom|left
 */
let formTooltip = (id, color = 'warning', placement = 'top') => {
  let title = $(`#${id}`).data('title') ?? 'Tooltip'
  $(`#${id}`).bstooltip({
    trigger: 'focus',
    placement: placement,
    template: /*html*/ `
    <div class="tooltip" role="tooltip">
      <div class="arrow arrow-${placement}-${color}"></div>
      <div class="tooltip-inner bg-gradient-${color} border border-${color}"></div>
    </div>
    `,
    title: title,
  })
}

/**
 * @description fungsi ini akan menghapus data di database berdasarkan id
 * @function deleteData
 *
 * @param {number} id id data
 */
let deleteData = (id) => {
  const swalWithBootstrapButtons = Swal.mixin({
    customClass: {
      confirmButton: 'btn bg-gradient-danger ml-2',
      cancelButton: 'btn bg-gradient-light',
    },
    buttonsStyling: false,
  })

  swalWithBootstrapButtons
    .fire({
      position: 'top',
      title: 'Apakah Anda yakin?',
      text: 'Anda tidak akan dapat mengembalikan data ini!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Hapus',
      cancelButtonText: 'Batal',
      reverseButtons: true,
    })
    .then((result) => {
      if (result.value) {
        let data = `id=${id}`
        let url = `${main_url}/remove`
        $.post(
          url,
          data,
          (res) => {
            if (res.success) {
              window.location = main_url
            } else {
              flash(res.msg, 'error')
            }
          },
          'JSON'
        )
      } else if (
        /* Read more about handling dismissals below */
        result.dismiss === Swal.DismissReason.cancel
      ) {
        flash('Hapus data batal.', 'error')
      }
    })
}

let upload = (param) => {
  /**
   * * Mendefinisikan variable
   */
  let input = $(param)
  let id = input.data('id') // ? field id
  let preview = $(`#preview_${id}`) // ? file preview
  let file_action = $(`#file_action_${id}`) // ? file action: download
  let files = input[0].files[0]
  let accept = input.attr('accept')
  let url = `${base_url}/file/upload`

  /**
   * * Mendefinisikan Input Data
   */
  let fd = new FormData()
  fd.append('file', files)
  fd.append('accept', accept)

  // ToDO: Ajax Request
  $.ajax({
    url: url,
    type: 'post',
    data: fd,
    dataType: 'json',
    contentType: false,
    processData: false,
    success: function (data) {
      // TODO: Menampilkan Alert
      flash(data.alert.message, data.alert.type)

      // TODO: Cek Status Upload
      if (data.alert.type == 'warning') {
        // ? Upload Berhasil

        // TODO: Menampilkan preview gambar
        preview.show()
        preview.find('img').attr({
          src: data.source,
          alt: data.filename,
        })
        preview.find('a').attr({
          href: data.source,
        })

        // TODO: Menampilkan link download dari file yang diupload
        file_action.show()
        file_action.find('.filename').text(data.filename)
        file_action.find('a').attr('href', data.source)

        // TODO: Set input value untuk file upload
        $(`#${id}`).val(data.filename)

        const re = /(?:\.([^.]+))?$/

        String.prototype.trunc =
          String.prototype.trunc ||
          function (n) {
            return this.length > n
              ? this.substr(0, n - 1) + ' &hellip; ' + re.exec(this)[0]
              : this
          }

        $(`#${id}`)
          .siblings('.input-group')
          .find('.custom-file-label')
          .html(data.filename.trunc(15))
      } else if (data.alert.type == 'error') {
        // ! upload gagal
        $(`#${id}`).siblings('.input-group').find('.custom-file-label').text('')
      }
    },
  })
}
