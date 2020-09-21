<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}
{include 'Templates/pagination.tpl'}

{block 'style'}
<!-- Ekko Lightbox -->
<link
  rel="stylesheet"
  href="{$smarty.const.BASE_URL}/assets/plugins/ekko-lightbox/ekko-lightbox.css"
/>
<!-- prettier-ignore -->
{/block}

{block name='content'}
<div class="row mb-3">
  <div class="col-12">
    {include 'Templates/buttons/add.tpl'}
  </div>
</div>

<div class="row">
  <div class="col-12">
    <div class="card rounded-0">
      <div class="card-header bg-gradient-navy rounded-0">
        <h3 class="card-title text-warning">{$subtitle}</h3>
        <div class="card-tools">
          <div class="input-group input-group-sm" style="width: 150px;">
            <input
              type="text"
              id="keyword"
              name="keyword"
              class="form-control float-right"
              value="{$keyword}"
              data-title="Cari Kode Program"
            />
            <div class="input-group-append">
              <button type="button" class="btn btn-default" id="searchBtn">
                <i class="fas fa-search"></i>
              </button>
            </div>
          </div>
        </div>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-0">
        <table class="table table-bordered table-sm">
          <thead>
            <tr>
              <th class="align-middle text-right" width="50px">#</th>
              <th class="align-middle text-center" width="80px">
                Tahun Anggaran
              </th>
              <th class="align-middle text-center" width="*">Nama Paket</th>
              <th class="align-middle text-center" width="100px">
                Tanggal Progres
              </th>
              <th class="align-middle text-center" width="80px">
                Progres Fisik
              </th>
              <th class="align-middle text-center" width="150px">
                Progres Keuangan
              </th>
              <th width="200pxpx">&nbsp;</th>
            </tr>
          </thead>
          <tbody id="result_data"></tbody>
        </table>
      </div>
      <!-- /.card-body -->

      <div class="card-footer clearfix">{block 'pagination'}{/block}</div>
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- prettier-ignore -->
{/block} 

{block 'script'}
<!-- Ekko Lightbox -->
<script src="{$smarty.const.BASE_URL}/assets/plugins/ekko-lightbox/ekko-lightbox.min.js"></script>

<!-- prettier-ignore -->
{block 'paginationJS'}{/block}
{literal}
<script>
  $(document).ready(function () {
    search()

    formTooltip('keyword', 'warning', 'top')

    $('#searchBtn').click(() => {
      search()
    })

    $(document).on('click', '[data-toggle="lightbox"]', function (event) {
      event.preventDefault()
      $(this).ekkoLightbox({
        alwaysShowClose: false,
      })
    })
  })

  let search = (page = 1) => {
    let params = {}
    params['page'] = page
    params['keyword'] = $('#keyword').val()

    const ROWS_PER_PAGE = '{/literal}{$smarty.const.ROWS_PER_PAGE}{literal}'

    $.post(
      `${main_url}/search`,
      params,
      (res) => {
        let paging = res.info

        let list = res.list
        let tBody = document.getElementById('result_data')
        tBody.innerHTML = ''
        let tRow = null
        let no = null,
          progFiscalYear = null,
          pkgdName = null,
          progDate = null,
          progPhysical = null,
          progFinance = null,
          action = null

        for (let index in list) {
          //#region Number
          no = document.createElement('td')
          no.classList.add('text-right')
          no.innerHTML =
            Number(ROWS_PER_PAGE) * (Number(paging.currentPage) - 1) +
            Number(index) +
            1
          //#endregion

          //#region Package Fiscal Year
          progFiscalYear = document.createElement('td')
          progFiscalYear.innerHTML = list[index].prog_fiscal_year
          //#endregion

          //#region Package Detail Name
          pkgdName = document.createElement('td')
          pkgdName.innerHTML = list[index].pkgd_name
          //#endregion

          //#region Progress Date
          progDate = document.createElement('td')
          progDate.innerHTML = list[index].prog_date
          //#endregion

          //#region Physical Progress
          progPhysical = document.createElement('td')
          progPhysical.classList.add('text-right')
          progPhysical.innerHTML = list[index].prog_physical
          //#endregion

          //#endregion Finance Progress
          progFinance = document.createElement('td')
          progFinance.classList.add('text-right')
          progFinance.innerHTML = list[index].prog_finance
          //#endregion

          //#region Action
          let imgBtn = null,
            docBtn = null

          //#region Image Button
          imgBtn = document.createElement('a')
          imgBtn.classList.add('badge', 'badge-info', 'badge-pill')
          imgBtn.dataset.toggle = 'lightbox'
          imgBtn.href =
            list[index].prog_img != '' && list[index].prog_img != null
              ? `${base_url}/upload/img/progress/${list[index].id}/${list[index].prog_img}`
              : 'javascript:void(0)'
          imgBtn.innerHTML = 'Foto'
          //#endregion

          //#region Document Button
          docBtn = document.createElement('a')
          docBtn.classList.add('badge', 'badge-secondary', 'badge-pill')
          docBtn.href = 'javascript:void(0)'
          if (list[index].prog_doc != '' && list[index].prog_doc != null) {
            docBtn.setAttribute('target', 'blank_')
            docBtn.href = `${base_url}/upload/pdf/progress/${list[index].id}/${list[index].prog_doc}`
          }
          docBtn.innerHTML = 'PDF'
          //#endregion

          action = document.createElement('td')
          action.appendChild(createEditBtn(list[index].id))
          action.appendChild(createDeleteBtn(list[index].id))
          action.appendChild(imgBtn)
          action.appendChild(docBtn)
          //#endregion

          //#region Row
          tRow = document.createElement('tr')
          tRow.appendChild(no)
          tRow.appendChild(progFiscalYear)
          tRow.appendChild(pkgdName)
          tRow.appendChild(progDate)
          tRow.appendChild(progPhysical)
          tRow.appendChild(progFinance)
          tRow.appendChild(action)
          //#endregion

          tBody.appendChild(tRow)
        }

        createPagination(page, paging, 'pagination')

        /* Tombol Hapus */
        $('.btn-delete').click(function () {
          deleteData($(this).data('id'))
        })
      },
      'JSON'
    )
  }
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
