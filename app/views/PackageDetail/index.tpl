{block 'detailStyle'}
<!-- Ekko Lightbox -->
<link
  rel="stylesheet"
  href="{$smarty.const.BASE_URL}/assets/plugins/ekko-lightbox/ekko-lightbox.css"
/>
<!-- prettier-ignore -->
{/block}

{block 'detailList'}
<legend>Detail</legend>
<div class="row mb-3">
  <div class="col-12">
    <button
      type="button"
      class="btn btn-flat bg-gradient-success"
      style="width: 100px;"
      id="detailAddBtn"
    >
      Tambah
    </button>
  </div>
</div>
<div class="row">
  <div class="col-12">
    <div class="table-responsive">
      <table class="table table-bordered table-sm" id="detailList">
        <thead>
          <tr>
            <th class="align-middle text-right" width="40px">#</th>
            <th class="align-middle text-center" width="15%">Nomor Paket</th>
            <th class="align-middle text-center" width="*">Nama Paket</th>
            <th class="align-middle text-center" width="10%">Jenis Masa</th>
            <th class="align-middle text-center" width="10%">Tahun Lanjutan</th>
            <th width="20%px">&nbsp;</th>
          </tr>
        </thead>
        <tbody id="result_data"></tbody>
      </table>
    </div>
  </div>
</div>
<!-- prettier-ignore -->
{/block}

{block 'detailJS'}
<!-- Ekko Lightbox -->
<script src="{$smarty.const.BASE_URL}/assets/plugins/ekko-lightbox/ekko-lightbox.min.js"></script>

{literal}
<script>
  $(document).ready(function () {
    pkgdRowEmpty()

    pkgdSearch()

    $('#detailAddBtn').click(() => {
      $('#detailFormModal').modal('show')
      $('#detailFormModalLabel').text('Tambah Paket')
    })

    $(document).on('click', '.btn-progress', function () {
      showProgress(this.dataset.id)
    })

    $(document).on('click', '.btn-target', function () {
      showTarget(this.dataset.id)
    })

    $(document).on('click', '.btn-partner', function () {
      showPartner(this.dataset.id)
    })

    $(document).on('click', '[data-toggle="lightbox"]', function (event) {
      event.preventDefault()
      $(this).ekkoLightbox({
        alwaysShowClose: false,
      })
    })
  })

  let detailList = document.querySelector('#detailList #result_data')

  let pkgdSearch = () => {
    $.post(
      `${BASE_URL}/packagedetail/search`,
      { pkg_id: $('#my_form #id').val() },
      (res) => {
        if (res.length > 0) {
          $('#detailList #emptyRow').remove()
          detailList.innerHTML = ''
          let list = res
          for (let index in list) {
            let tRow = null
            let no = null,
              pkgdNo = null,
              pkgdName = null,
              pkgdPeriodType = null,
              pkgdAdvancedYear = null,
              action = null,
              detail = null

            no = createElement({
              element: 'td',
              class: ['text-right'],
            })

            pkgdNo = createElement({
              element: 'td',
              children: [list[index].pkgd_no],
            })

            pkgdName = createElement({
              element: 'td',
              children: [list[index].pkgd_name],
            })

            pkgdPeriodType = createElement({
              element: 'td',
              children: [list[index].pkgd_period_type],
            })

            pkgdAdvancedYear = createElement({
              element: 'td',
              class: ['text-center'],
              children: [
                list[index].pkgd_advanced_year == 1 ? yesText : noText,
              ],
            })

            let actionBtns = null,
              contractorBtn = null,
              targetBtn = null,
              progressBtn = null,
              imgBtn = null,
              editBtn = null,
              deleteBtn = null

            contractorBtn = createElement({
              element: 'a',
              class: ['btn', 'btn-info', 'btn-sm', 'btn-contractor'],
              data: {
                id: list[index].id,
              },
              attribute: {
                href: 'javascript:void(0)',
              },
              children: ['Kontraktor'],
            })

            targetBtn = createElement({
              element: 'a',
              class: ['btn', 'btn-info', 'btn-sm', 'btn-target'],
              data: {
                id: list[index].id,
              },
              attribute: {
                href: 'javascript:void(0)',
              },
              children: ['Target'],
            })

            progressBtn = createElement({
              element: 'a',
              class: ['btn', 'btn-info', 'btn-sm', 'btn-progress'],
              data: {
                id: list[index].id,
              },
              attribute: {
                href: 'javascript:void(0)',
              },
              children: ['Progres'],
            })

            imgBtn = createElement({
              element: 'a',
              class: ['btn', 'btn-info', 'btn-sm'],
              data: {
                toggle: 'lightbox',
              },
              attribute: {
                href:
                  list[index].pkgd_last_prog_img != '' &&
                  list[index].pkgd_last_prog_img != null
                    ? `${BASE_URL}/upload/${list[index].pkgd_last_prog_img}`
                    : 'javascript:void(0)',
              },
              children: ['Foto'],
            })
            imgBtn.disabled =
              [index].pkgd_last_prog_img != '' &&
              list[index].pkgd_last_prog_img != null
                ? false
                : true

            editBtn = createElement({
              element: 'a',
              class: ['badge', 'badge-pill', 'badge-warning', 'mr-1'],
              attribute: {
                href: `${MAIN_URL}/edit/${list[index].id}`,
              },
              children: ['Edit'],
            })

            deleteBtn = createElement({
              element: 'a',
              class: ['badge', 'badge-pill', 'badge-danger', 'btn-delete'],
              data: {
                id: list[index].id,
              },
              attribute: {
                href: `javascript:void(0)`,
              },
              children: ['Hapus'],
            })

            actionBtns = createElement({
              element: 'div',
              class: ['btn-group'],
              children: [contractorBtn, targetBtn, progressBtn, imgBtn],
            })

            action = createElement({
              element: 'td',
              children: [actionBtns],
            })

            detail = createElement({
              element: 'input',
              attribute: {
                type: 'hidden',
              },
            })
            Object.entries(list[index]).forEach(([key, value]) => {
              detail.dataset[camelCase(key)] = value
            })

            tRow = createElement({
              element: 'tr',
              children: [
                no,
                pkgdNo,
                pkgdName,
                pkgdPeriodType,
                pkgdAdvancedYear,
                action,
                detail,
              ],
            })

            detailList.appendChild(tRow)
          }
          reArrange('#detailList #result_data tr')
        }
      },
      'JSON'
    )
  }

  let pkgdRowEmpty = () => {
    const tCol = createElement({
      element: 'td',
      class: ['text-center'],
      attribute: {
        colspan: 6,
      },
      children: ['Data Kosong'],
    })

    const tRow = createElement({
      element: 'tr',
      attribute: {
        id: 'emptyRow',
      },
      children: [tCol],
    })

    detailList.appendChild(tRow)
  }

  let showProgress = (id) => {
    let data = $(`#detailList input[data-id=${id}]`).data()

    $('#progressModal').modal('show')
    $('#progressModalLabel').text(`Progres ${data.pkgdNo}`)

    $('#pkgdLastProgDate').val(data.pkgdLastProgDate)
    $('#pkgdSumProgPhysical').val(`${data.pkgdSumProgPhysical} %`)
    $('#pkgdSumProgFinance').val(`Rp ${data.pkgdSumProgFinance}`)
  }

  let showPartner = (id) => {
    const data = $(`#detailList input[data-id=${id}]`).data()

    $('#partnerFormModal').modal('show')
    $('#partnerFormModalLabel').text(`Rekanan ${data.pkgdNo}`)

    $.each(data, (key, value) => {
      key = key
        .replace(/\.?([A-Z]+)/g, function (x, y) {
          return '_' + y.toLowerCase()
        })
        .replace(/^_/, '')

      $(`#partner_form #${key}`).val(value)
    })
  }

  let showTarget = (id) => {
    const data = $(`#detailList input[data-id=${id}]`).data()

    $('#targetModal').modal('show')
    $('#targetModalLabel').text(`Target ${data.pkgdNo}`)
    $('#target_form #pkgd_id').val(id)

    searchTarget(id)
  }
</script>
{/literal} {/block}
