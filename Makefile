.PHONY: all build test clean vm-create vm-start vm-stop vm-destroy lint

all: build

build:
	cargo build --release

test:
	cargo test

lint:
	cargo fmt --check
	cargo clippy -- -D warnings

clean:
	cargo clean
	rm -rf out/

# VM management
vm-create:
	sudo virt-install \
		--name lnos-test \
		--memory 4096 \
		--vcpus 2 \
		--disk size=20,format=qcow2,path=/var/lib/libvirt/images/lnos-test.qcow2 \
		--cdrom /var/lib/libvirt/images/archlinux-x86_64.iso \
		--os-variant archlinux \
		--network network=default \
		--graphics vnc,listen=0.0.0.0 \
		--noautoconsole

vm-start:
	sudo virsh start lnos-test

vm-stop:
	sudo virsh shutdown lnos-test

vm-destroy:
	sudo virsh destroy lnos-test 2>/dev/null; \
	sudo virsh undefine lnos-test; \
	sudo rm -f /var/lib/libvirt/images/lnos-test.qcow2

vm-console:
	sudo virsh console lnos-test

# List modules
modules:
	./target/release/lnos-mod list

# Module info
module-info:
	./target/release/lnos-mod info $(MODULE)

# Generate docs
docs:
	cd docs && python3 -c "
import re
files = ['SPECIFICATION.md', 'SPEC_C41_80.md', 'SPEC_C81_120.md']
for f in files:
    with open(f) as fh:
        content = fh.read()
    chapters = re.findall(r'^## (\d+)\.\s+(.+)$', content, re.MULTILINE)
    print(f'\n=== {f} ===')
    for num, title in chapters:
        print(f'  {num}. {title}')
"
