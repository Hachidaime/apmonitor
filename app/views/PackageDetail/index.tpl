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
      class="btn btn-flat btn-success btn-sm"
      style="width: 100px;"
      id="detailAddBtn"
    >
      Tambah
    </button>
  </div>
</div>
<div class="row">
  <div class="col-12">
    <div class="table-responsive border border-bottom-0">
      <table
        class="table table-bordered table-sm text-nowrap mb-1 ml-0"
        style="min-width: 768px;"
      >
        <thead>
          <tr>
            <th
              class="align-middle text-right sticky-left"
              width="40px"
              style="
                /* Background color */
                background-color: #ffffff;

                /* Outline */
                outline: 1px solid #e9ecef;

                /* Stick to the left */
                left: 0px;
                position: sticky;

                /* Displayed on top of other rows when scrolling */
                z-index: 10;

                /* Box Shadow */
                /* box-shadow: 0 0 2px -1px rgba(0, 0, 0, 0.4); */
              "
            >
              #
            </th>
            <th
              class="align-middle text-center sticky-left"
              width="120px"
              style="
                /* Background color */
                background-color: #ffffff;

                /* Outline */
                outline: 1px solid #e9ecef;

                /* Stick to the left */
                left: 40px;
                position: sticky;

                /* Displayed on top of other rows when scrolling */
                z-index: 10;

                /* Box Shadow */
                /* box-shadow: 0 0 2px -1px rgba(0, 0, 0, 0.4); */
              "
            >
              Nomor Paket
            </th>
            <th class="align-middle text-center" width="*">
              Nama Paket
            </th>
            <th class="align-middle text-center" width="130px">
              Jenis<br />Masa
            </th>
            <th class="align-middle text-center" width="75px">
              Tahun<br />Lanjutan
            </th>
            <th width="230px">&nbsp;</th>
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

    btnRemoveClick()
    pkgdSearch()

    $('#detailAddBtn').click(() => {
      $('#detailFormModal').modal('show')
      $('#detailFormModalLabel').text('Tambah Paket')
    })

    $(document).on('click', '[data-toggle="lightbox"]', function (event) {
      event.preventDefault()
      $(this).ekkoLightbox({
        alwaysShowClose: false,
      })
    })
  })

  let tBody = document.getElementById('result_data')

  let pkgdSearch = () => {
    $.post(
      `${base_url}/packagedetail/search`,
      { pkg_id: $('#my_form #id').val() },
      (res) => {
        if (res.length > 0) {
          $('#emptyRow').remove()
          tBody.innerHTML = ''

          $.each(res, (idx, row) => {
            pkgdRow(row)
            btnRemoveClick()
          })

          rearrangeNumber()
        }
      },
      'JSON'
    )
  }

  let btnRemoveClick = () => {
    $('.btn-remove').click(function () {
      this.closest('tr').remove()
      rearrangeNumber()

      if (tBody.childElementCount == 0) pkgdRowEmpty()
    })
  }

  let rearrangeNumber = () => {
    let rowNo = 1
    tBody.querySelectorAll('tr').forEach(function (tr) {
      tr.firstChild.innerHTML = rowNo
      rowNo++
    })
  }

  let pkgdRow = (params = null) => {
    let tRow = document.createElement('tr')

    let no = null
    no = document.createElement('td')
    no.classList.add('text-right')
    no.style.backgroundColor = '#ffffff'
    no.style.left = '0'
    no.style.position = 'sticky'
    no.style.zIndex = '10'
    no.style.outline = '1px solid #e9ecef'
    no.innerHTML = params != null ? params.no : tBody.childElementCount + 1

    let pkgdNo = createPkgdNo(params != null ? params.pkgd_no : ''),
      pkgdName = createPkgdName(params != null ? params.pkgd_name : ''),
      pkgdPeriodType = createPkgdPeriodType(
        params != null ? params.pkgd_period_type : ''
      ),
      pkgdAdvancedYear = createPkgdAdvancedYear(
        params != null ? params.pkgd_advanced_year : ''
      ),
      action = createAction(params)

    tRow.appendChild(no)
    tRow.appendChild(pkgdNo)
    tRow.appendChild(pkgdName)
    tRow.appendChild(pkgdPeriodType)
    tRow.appendChild(pkgdAdvancedYear)
    tRow.appendChild(action)

    let detail = document.createElement('input')
    detail.setAttribute('type', 'hidden')
    $.each(params, (key, value) => {
      detail.dataset[camelCase(key)] = value
    })
    tRow.appendChild(detail)

    tBody.appendChild(tRow)
  }

  let createPkgdNo = (param) => {
    let pkgdNo = document.createElement('td')
    pkgdNo.style.backgroundColor = '#ffffff'
    pkgdNo.style.left = '40px'
    pkgdNo.style.position = 'sticky'
    pkgdNo.style.zIndex = '10'
    pkgdNo.style.outline = '1px solid #e9ecef'
    pkgdNo.innerHTML = param

    return pkgdNo
  }

  let createPkgdName = (param) => {
    let pkgdName = document.createElement('td')
    pkgdName.innerHTML = param

    return pkgdName
  }

  let createPkgdPeriodType = (param) => {
    let pkgdPeriodType = document.createElement('td')
    pkgdPeriodType.innerHTML = param

    return pkgdPeriodType
  }

  let createPkgdAdvancedYear = (param) => {
    let pkgdAdvancedYear = document.createElement('td')
    pkgdAdvancedYear.classList.add('text-center')
    pkgdAdvancedYear.innerHTML = param == 1 ? yesText : noText

    return pkgdAdvancedYear
  }

  let createAction = (params) => {
    let partnerBtn = document.createElement('a')
    partnerBtn.classList.add('btn', 'btn-info', 'btn-sm')
    partnerBtn.href = 'javascript:void(0)'
    partnerBtn.innerHTML = 'Rekanan'

    let targetBtn = document.createElement('a')
    targetBtn.classList.add('btn', 'btn-info', 'btn-sm')
    targetBtn.href = 'javascript:void(0)'
    targetBtn.innerHTML = 'Target'

    let progressBtn = document.createElement('a')
    progressBtn.classList.add('btn', 'btn-info', 'btn-sm')
    progressBtn.href = 'javascript:void(0)'
    progressBtn.setAttribute('onclick', `showProgress(${params.id})`)
    progressBtn.innerHTML = 'Progres'

    let imageBtn = document.createElement('a')
    imageBtn.classList.add('btn', 'btn-info', 'btn-sm')
    imageBtn.dataset.toggle = 'lightbox'
    imageBtn.href =
      params.pkgd_last_prog_img != '' && params.pkgd_last_prog_img != null
        ? `${base_url}/upload/${params.pkgd_last_prog_img}`
        : 'javascript:void(0)'
    imageBtn.innerHTML = 'Foto'

    let editBtn = document.createElement('a')
    editBtn.classList.add('btn', 'btn-info', 'btn-sm')
    editBtn.href = 'javascript:void(0)'
    editBtn.innerHTML = 'Ubah'

    let removeBtn = document.createElement('a')
    removeBtn.classList.add('btn', 'btn-info', 'btn-sm', 'btn-remove')
    removeBtn.href = 'javascript:void(0)'
    removeBtn.innerHTML = 'Hapus'

    let actionBtn = document.createElement('div')
    actionBtn.classList.add('btn-group')
    actionBtn.appendChild(partnerBtn)
    actionBtn.appendChild(targetBtn)
    actionBtn.appendChild(progressBtn)
    actionBtn.appendChild(imageBtn)
    // actionBtn.appendChild(editBtn)
    // actionBtn.appendChild(removeBtn)

    let action = document.createElement('td')
    action.appendChild(actionBtn)

    return action
  }

  let pkgdRowEmpty = () => {
    let tCol = document.createElement('td')
    tCol.classList.add('text-center')
    tCol.setAttribute('colspan', 6)
    tCol.innerHTML = 'Data Kosong.'

    let tRow = document.createElement('tr')
    tRow.setAttribute('id', 'emptyRow')
    tRow.appendChild(tCol)
    tBody.appendChild(tRow)
  }

  let showProgress = (id) => {
    let data = $(`input[data-id=${id}]`).data()

    $('#progressModal').modal('show')
    $('#progressModalLabel').text(`Progres ${data.pkgdNo}`)

    $('#pkgdLastProgDate').val(data.pkgdLastProgDate)
    $('#pkgdSumProgPhysical').val(`${data.pkgdSumProgPhysical} %`)
    $('#pkgdSumProgFinance').val(`Rp ${data.pkgdSumProgFinance}`)
  }

  let showImage = (id) => {
    // Code
  }
</script>
{/literal} {/block}
