<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}
{include 'Templates/pagination.tpl'}

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
{block 'paginationJS'}{/block}
{literal}
<script>
  $(document).ready(function () {
    search()

    formTooltip('keyword', 'warning', 'top')

    $('#searchBtn').click(() => {
      search()
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
          no = document.createElement('td')
          no.classList.add('text-right')
          no.innerHTML =
            Number(ROWS_PER_PAGE) * (Number(paging.currentPage) - 1) +
            Number(index) +
            1

          progFiscalYear = document.createElement('td')
          progFiscalYear.innerHTML = list[index].prog_fiscal_year

          pkgdName = document.createElement('td')
          pkgdName.innerHTML = list[index].pkgd_name

          progDate = document.createElement('td')
          progDate.innerHTML = list[index].prog_date

          progPhysical = document.createElement('td')
          progPhysical.classList.add('text-right')
          progPhysical.innerHTML = list[index].prog_physical

          progFinance = document.createElement('td')
          progFinance.classList.add('text-right')
          progFinance.innerHTML = list[index].prog_finance

          let editBtn = createEditBtn(list[index].id)
          let deleteBtn = createDeleteBtn(list[index].id)

          action = document.createElement('td')
          action.appendChild(editBtn)
          action.appendChild(deleteBtn)

          tRow = document.createElement('tr')
          tRow.appendChild(no)
          tRow.appendChild(progFiscalYear)
          tRow.appendChild(pkgdName)
          tRow.appendChild(progDate)
          tRow.appendChild(progPhysical)
          tRow.appendChild(progFinance)
          tRow.appendChild(action)

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
