<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}

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
          <form
            action="{$smarty.const.BASE_URL}/{$smarty.session.ACTIVE.name}"
            method="post"
          >
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
                <button type="submit" class="btn btn-default">
                  <i class="fas fa-search"></i>
                </button>
              </div>
            </div>
          </form>
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
              <th class="align-middle text-center" width="120px">&nbsp;</th>
            </tr>
          </thead>
          <tbody>
            {section name=outer loop=$list}
            <tr class="list-row" data-id="{$list[outer].id}">
              <td class="text-right" scope="row">
                {$smarty.const.ROWS_PER_PAGE * ($paging.currentPage - 1) +
                $smarty.section.outer.index + 1}
              </td>
              <td>{$list[outer].usr_name}</td>
              <td>{$list[outer].usr_username}</td>
              <td class="text-center">
                {if $list[outer].usr_is_master eq 1} {$yes} {else} {$no} {/if}
              </td>
              <td class="text-center">
                {if $list[outer].usr_is_package eq 1} {$yes} {else} {$no} {/if}
              </td>
              <td class="text-center">
                {if $list[outer].usr_is_report eq 1} {$yes} {else} {$no} {/if}
              </td>
              <td>
                <!-- prettier-ignore -->
                {include 'Templates/buttons/edit.tpl'}
                {if $list[outer].id ne $smarty.session.USER.id}
                {include 'Templates/buttons/remove.tpl'}
                {/if}
              </td>
            </tr>
            {sectionelse}
            <tr>
              <td colspan="5" class="text-center">Data kosong ...</td>
            </tr>
            {/section}
          </tbody>
        </table>
      </div>
      <!-- /.card-body -->

      <div class="card-footer clearfix">
        {$pager}
      </div>
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- prettier-ignore -->
{/block} 

{block 'script'} 
{literal}
<script>
  $(document).ready(function () {
    formTooltip('keyword', 'warning', 'top')

    /* Tombol Hapus */
    $('.btn-delete').click(function () {
      deleteData($(this).data('id'))
    })
  })
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
