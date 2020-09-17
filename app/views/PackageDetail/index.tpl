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
    <div class="table-responsive">
      <table
        class="table table-hover table-bordered table-striped table-sm text-nowrap mb-0"
        style="min-width: 768px;"
      >
        <thead>
          <tr>
            <th
              class="align-middle text-right sticky-left"
              width="40px"
              style="
                /* Background color */
                background-color: #dee2e6;

                /* Stick to the left */
                left: 0;
                position: sticky;

                /* Displayed on top of other rows when scrolling */
                z-index: 10;
              "
            >
              #
            </th>
            <th
              class="align-middle text-center sticky-left"
              width="120px"
              style="
                /* Background color */
                background-color: #dee2e6;

                /* Stick to the left */
                left: 40px;
                position: sticky;

                /* Displayed on top of other rows when scrolling */
                z-index: 10;
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
{literal}
<script>
  $(document).ready(function () {
    pkgdRowEmpty()

    btnRemoveClick()

    $('#detailAddBtn').click(() => {
      // $('#emptyRow').remove()
      // pkgdRow()
      // btnRemoveClick()
      $('#detailFormModal').modal('show')
      $('#detailFormModalLabel').text('Tambah Paket')
    })
  })

  let tBody = document.getElementById('result_data')

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
    no.style.backgroundColor = '#dee2e6'
    no.style.left = '0'
    no.style.position = 'sticky'
    no.style.zIndex = '10'
    no.innerHTML = params != null ? params.no : tBody.childElementCount + 1

    let pkgdNo = createPkgdNo(params != null ? params.pkgd_no : ''),
      pkgdName = createPkgdName(params != null ? params.pkgd_name : ''),
      pkgdPeriodType = createPkgdPeriodType(
        params != null ? params.pkgd_period_type : ''
      ),
      pkgdAdvancedYear = createPkgdAdvancedYear(
        params != null ? params.pkgd_advanced_year : ''
      ),
      action = createAction()

    tRow.appendChild(no)
    tRow.appendChild(pkgdNo)
    tRow.appendChild(pkgdName)
    tRow.appendChild(pkgdPeriodType)
    tRow.appendChild(pkgdAdvancedYear)
    tRow.appendChild(action)

    tBody.appendChild(tRow)
  }
  //   background-color: #dee2e6;

  // /* Stick to the left */
  // left: 40px;
  // position: sticky;

  // /* Displayed on top of other rows when scrolling */
  // z-index: 10;
  let createPkgdNo = (param) => {
    let pkgdNo = document.createElement('td')
    pkgdNo.style.backgroundColor = '#dee2e6'
    pkgdNo.style.left = '40px'
    pkgdNo.style.position = 'sticky'
    pkgdNo.style.zIndex = '10'
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
    pkgdAdvancedYear.innerHTML = param

    return pkgdAdvancedYear
  }

  let createAction = () => {
    let partnerBtn = document.createElement('a')
    partnerBtn.classList.add('btn', 'btn-default', 'btn-sm')
    partnerBtn.href = 'javascript:void(0)'
    partnerBtn.innerHTML = 'Rekanan'

    let targetBtn = document.createElement('a')
    targetBtn.classList.add('btn', 'btn-default', 'btn-sm')
    targetBtn.href = 'javascript:void(0)'
    targetBtn.innerHTML = 'Target'

    let progressBtn = document.createElement('a')
    progressBtn.classList.add('btn', 'btn-default', 'btn-sm')
    progressBtn.href = 'javascript:void(0)'
    progressBtn.innerHTML = 'Progres'

    let imageBtn = document.createElement('a')
    imageBtn.classList.add('btn', 'btn-default', 'btn-sm')
    imageBtn.href = 'javascript:void(0)'
    imageBtn.innerHTML = 'Foto'

    let editBtn = document.createElement('a')
    editBtn.classList.add('btn', 'btn-default', 'btn-sm')
    editBtn.href = 'javascript:void(0)'
    editBtn.innerHTML = 'Ubah'

    let removeBtn = document.createElement('a')
    removeBtn.classList.add('btn', 'btn-default', 'btn-sm', 'btn-remove')
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
</script>
{/literal} {/block}
