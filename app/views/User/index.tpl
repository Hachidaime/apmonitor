<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}
{include 'Templates/pagination.tpl'}

{block name='content'}
{assign 'yes' '<span class="text-success">YES</span>'}
<!-- prettier-ignore -->
{assign 'no' '<span class="text-danger">NO</span>'}
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
              data-title="Cari Nama User"
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
        <table class="table table-hover table-bordered table-sm text-nowrap">
          <thead>
            <tr>
              <th class="align-middle text-right" width="50px">#</th>
              <th class="align-middle text-center" width="*">Nama</th>
              <th class="align-middle text-center" width="180px">
                Username
              </th>
              <th class="align-middle text-center" width="100px">
                Privilege<br />Master
              </th>
              <th class="align-middle text-center" width="100px">
                Privilege<br />Paket
              </th>
              <th class="align-middle text-center" width="100px">
                Privilege<br />Laporan
              </th>
              <th class="align-middle text-center" width="130px">&nbsp;</th>
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

    $('#page').change(function () {
      search(this.value)
    })

    $('#previousBtn').click(function () {
      search(this.dataset.id)
    })

    $('#nextBtn').click(function () {
      search(this.dataset.id)
    })
  })

  let yesText = '<span class="text-success">YES</span>'
  let noText = '<span class="text-danger">NO</span>'

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
          usrUsername = null,
          usrName = null,
          userIsMaster = null,
          userIsPackage = null,
          userIsReport = null,
          action = null

        for (let index in list) {
          no = document.createElement('td')
          no.classList.add('text-right')
          no.innerHTML =
            Number(ROWS_PER_PAGE * (paging.currentPage - 1)) + Number(index) + 1

          usrName = document.createElement('td')
          usrName.innerHTML = list[index].usr_name

          usrUsername = document.createElement('td')
          usrUsername.innerHTML = list[index].usr_username

          userIsMaster = document.createElement('td')
          userIsMaster.innerHTML =
            list[index].usr_is_master == 1 ? yesText : noText

          userIsPackage = document.createElement('td')
          userIsPackage.innerHTML =
            list[index].usr_is_package == 1 ? yesText : noText

          userIsReport = document.createElement('td')
          userIsReport.innerHTML =
            list[index].usr_is_report == 1 ? yesText : noText

          let editBtn = createEditBtn(list[index].id)
          let deleteBtn = createDeleteBtn(list[index].id)

          action = document.createElement('td')
          action.appendChild(editBtn)

          let sessionUserId = '{/literal}{$smarty.session.USER.id}{literal}'
          if (list[index].id != sessionUserId) action.appendChild(deleteBtn)

          tRow = document.createElement('tr')
          tRow.appendChild(no)
          tRow.appendChild(usrName)
          tRow.appendChild(usrUsername)
          tRow.appendChild(userIsMaster)
          tRow.appendChild(userIsPackage)
          tRow.appendChild(userIsReport)
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
