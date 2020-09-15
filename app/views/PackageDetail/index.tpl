<!-- prettier-ignore -->
{include 'PackageDetail/form.tpl'}

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
  <div class="col-12 table-responsive">
    <table class="table table-hover table-bordered table-sm text-nowrap">
      <thead>
        <tr>
          <th class="align-middle text-right" width="50px">#</th>
          <th class="align-middle text-center" width="150px">
            Nomor Paket
          </th>
          <th class="align-middle text-center" width="*">Nama Paket</th>
          <th class="align-middle text-center" width="120px">
            Jenis<br />Masa
          </th>
          <th class="align-middle text-center" width="120px">
            Tahun<br />Lanjutan
          </th>
          <th width="240px">&nbsp;</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td colspan="6" class="text-center">Data kosong ...</td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
<!-- prettier-ignore -->
{block 'detailForm'}{/block}
{/block}

{block 'detailJS'}
<script>
  $(document).ready(function () {
    $('#detailAddBtn').click(() => {
      $('#detailFormModal').modal('show')
    })
  })
</script>
{/block}
